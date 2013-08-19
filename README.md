# LocomotiveCMS::LiquidExtensions

This gem includes list of useful Liquid blocks, tags and filters which can be all embedded in both **Wagon** and the **LocomotiveCMS engine**.
Behind the scene, it uses Solid to write reliable and consistant liquid code.

For now, it only works best with the edge versions of Wagon and the engine (master branch).

## List of tags / blocks

### send_email

#### Description

Send an email directly from a liquid template. Although, it does break the MVC pattern, it is reasonable to use it within a LocomotiveCMS site for simple needs.

The emails are sent by [Pony](https://github.com/benprew/pony). It is disabled in Wagon, only the logs are output.

#### Usage

The code inside {% sendemail %} and {% endsendemail %} serves as the body of the email. You can access the whole context of your page within the body.

    {% if post? and params.email != '' %}
      <p>Email sent to {{ params.email }}</p>

      {% send_email to: params.email, from: 'me@locomotivecms.com', subject: 'Hello world', page_handle: 'email-template', smtp_address: 'smtp.example.com', smtp_user_name: 'user', smtp_password: 'password' %}

        Hello {{ send_email.to }},

        Lorem ipsum....

      {% endsend_email %}

    {% else %}
      ....
    {% endif}

Note: In order to set up the smtp server in Pony, use the smtp_**** attributes.

If you want to use a page as the template for the email, use the page_handle property which is the handle of your page.

    {% send_email to: params.email, from: 'me@locomotivecms.com', subject: 'Hello world', page_handle: 'email-template', smtp_address: 'smtp.example.com', smtp_user_name: 'user', smtp_password: 'password' %}{% endsend_email %}


### update

#### Description

Update the attributes of a content entry. Again, it does break the MVC pattern, so use it wisely.

#### Usage

    {% update project, title: 'Your new title' %}
    <p>The project gets updated with success</p>
    {% else %}
    <p>Arrggh, there was an error.</p>
    {% endupdate %}

Note: The whole context of the page is available in the 2 blocks.

## Installation

### Wagon

In your Wagon site, add the following line to your Gemfile:

    group :misc do
      gem 'locomotivecms_liquid_extensions', github: 'locomotivecms/liquid_extensions'
    end

### Engine

In the Gemfile of your engine, add the following line:

    gem 'locomotivecms_liquid_extensions', github: 'locomotivecms/liquid_extensions'


## Developers / Contributors

First, get the source

    $ git clone git://github.com/locomotivecms/liquid_extensions.git
    $ cd liquid_extensions

Note: Again, if you want to contribute, you may consider to fork it instead

    $ bundle install

### Test it

Run the tests suite

    $ bundle exec rake spec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contact

Feel free to contact me at did at locomotivecms dot com.

Copyright (c) 2013 NoCoffee, released under the MIT license
