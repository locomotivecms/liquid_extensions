require 'spec_helper'

describe Locomotive::LiquidExtensions::Tags::SendEmail do

  let(:tag_class) { Locomotive::LiquidExtensions::Tags::SendEmail }

  describe '#display' do

    let(:tokens) { ['Hello ', '{{ send_email.to }}', '{% endsend_email %}', 'outside'] }
    let(:attachment) { '' }
    let(:options) { "to: 'john@doe.net', from: 'me@locomotivecms.com', subject: 'Hello world', html: false, smtp_address: 'smtp.example.com', smtp_user_name: 'user', smtp_password: 'password'#{attachment}" }
    let(:assigns) { {} }
    let(:context) { Liquid::Context.new({}, assigns, { logger: CustomLogger }) }

    subject { tag_class.new('send_email', options, tokens) }

    it 'sends the email over Pony' do
      Pony.expects(:mail).with(
        to:           'john@doe.net',
        from:         'me@locomotivecms.com',
        subject:      'Hello world',
        body:         'Hello john@doe.net',
        via:          :smtp,
        via_options:  {
          address:    'smtp.example.com',
          user_name:  'user',
          password:   'password'
        }
      )
      subject.render(context).should be == ''
    end

    context 'with an attachment' do

      context 'inline content' do

        let(:attachment) { ", attachment_name: 'foo.txt', attachment_value: 'Hello world'" }

        it 'sends the email over Pony' do
          Pony.expects(:mail).with(
            to:           'john@doe.net',
            from:         'me@locomotivecms.com',
            subject:      'Hello world',
            body:         'Hello john@doe.net',
            via:          :smtp,
            via_options:  {
              address:    'smtp.example.com',
              user_name:  'user',
              password:   'password'
            },
            attachments:   {
              'foo.txt' => 'Hello world'
            }
          )
          subject.render(context).should be == ''
        end

      end

      context 'remote content' do

        let(:assigns) { { 'host' => 'acme.org' } }
        let(:attachment) { ", attachment_name: 'foo.txt', attachment_value: '/somewhere/foo.txt'" }

        describe 'mocked' do

            before do
            Net::HTTP.expects(:get).with(URI('http://acme.org/somewhere/foo.txt')).returns('Hello world [file]')
          end

          it 'sends the email over Pony' do
            Pony.expects(:mail).with(
              to:           'john@doe.net',
              from:         'me@locomotivecms.com',
              subject:      'Hello world',
              body:         'Hello john@doe.net',
              via:          :smtp,
              via_options:  {
                address:    'smtp.example.com',
                user_name:  'user',
                password:   'password'
              },
              attachments:   {
                'foo.txt' => 'Hello world [file]'
              }
            )
            subject.render(context).should be == ''
          end

        end

        if ENV['SENDGRID_USERNAME'] && ENV['SENDGRID_PASSWORD']
          describe 'for real' do

            let(:attachment) { ", attachment_name: 'foo.pdf', attachment_value: 'https://hosting-staging.s3.amazonaws.com/sites/535e3188e7f604312d000001/content_entry535e31d1e7f60485b5000002/535e326ae7f604312d000020/files/O0000DSJ0ZJQK8O.pdf'" }
            let(:options) { "to: 'didier@nocoffee.fr', from: 'lepal@insert.fr', subject: 'Hello world', html: false, smtp_address: 'smtp.sendgrid.net', smtp_user_name: '#{ENV['SENDGRID_USERNAME']}', smtp_password: '#{ENV['SENDGRID_PASSWORD']}', smtp_port: '587', smtp_authentication: 'plain', smtp_enable_starttls_auto: 'true'#{attachment}" }

            it 'sends for real the email' do
              lambda { subject.render(context) }.should_not raise_exception
            end

          end
        end

      end

    end

    context 'in Wagon' do

      let(:assigns) { { 'wagon' => true } }

      it 'does not send the email' do
        Pony.expects(:mail).never
        subject.render(context).should be == ''
      end

      it 'logs the message' do
        CustomLogger.expects(:info)
        subject.render(context).should be == ''
      end

    end

    context 'using a page as the body of the email' do

      let(:options) { "to: 'john@doe.net', from: 'me@locomotivecms.com', subject: 'Hello world', page_handle: 'email_template', smtp_address: 'smtp.example.com', smtp_user_name: 'user', smtp_password: 'password'" }
      let(:page) { SimplePage.new("Hello {{ send_email.to }}, Lorem ipsum...")}

      it 'sends the email over Pony' do
        subject.expects(:fetch_page).returns(page)
        Pony.expects(:mail).with(
          to:         'john@doe.net',
          from:       'me@locomotivecms.com',
          subject:    'Hello world',
          html_body:  'Hello john@doe.net, Lorem ipsum...',
          via:      :smtp,
          via_options: {
            address:    'smtp.example.com',
            user_name:  'user',
            password:   'password'
          }
        )
        subject.render(context).should be == ''
      end

      it 'raises an error if the page does not exist' do
        subject.expects(:fetch_page).returns(nil)
        lambda { subject.render(context) }.should raise_exception(%{[send_email] No page found with "email_template" as handle.})
      end

    end

  end

end