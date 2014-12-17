# LocomotiveCMS::LiquidExtensions

This gem includes list of useful Liquid blocks, tags and filters which can be all embedded in both **Wagon** and the **LocomotiveCMS engine**.
Behind the scene, it uses Solid to write reliable and consistant liquid code.

For now, it only works best with the edge versions of Wagon and the engine (master branch).

## List of filters

### json

#### Description

The json filter escapes quotes. It can also work on arrays and collections.

#### Usage

Escape quotes of the name of the current site:

    {{ site.name | json }}

Output a single attribute of a collection of content entries:

    {{ projects.all | json: name }}

    "Project #1","Project #2",...,"Project #3"

Output only the name and the description of the list of projects

    {{ projects.all | json: name, description }}

    {"name":"Project #1","description":"Lorem ipsum"},...,{"name":"Project #n","description":"Lorem ipsum"}

### money

#### Description

Formats a number into a currency string (e.g., $13.65). You can customize the format in the options.

#### Usage

    {{ "42.00" | money }}
    {{ product.price | money: "precision:2, unit:'€', separator:',', delimiter:'', format:'%n %u'" }}

### percentage

#### Description

Formats a number as a percentage string (e.g., 65%). You can customize the format in the options

#### Usage

    {{ "100" | percentage }}
    {{ a_percentage | percentage: "precision:2, separator:',', delimiter:'', significant:true" }}

## List of tags / blocks

### for

#### Description

It behaves exactly like the default liquid **for** but with the exception of having an extra property named "join".

#### Usage

    {% for project in projects join: ", " %}{{ project.name }}{% enfor %}

    Project #1, Project #2, Project #3

### cache ###

#### Description ####

Wrap `Rails.cache.fetch` with a `{% cache %}` liquid tag. Useful for
partial page caching above and beyond existing LocomotiveCMS caching
features. For example, around content entry loops rendering snippets.

#### Usage ####

Wrap blocks of code in your template with the `{% cache %}` tag, sending in 
one or more keys to be used. Keys can be either strings or page-level variables which will be evaluated.
Send in multiple keys as comma-separated list.

For example:

    {% assign variable = 'key2' %}
    {% cache 'key1', variable, 'key3' %}
      {% for example in contents.examples %}
        {% include 'example_item' with example %}
      {% endfor %}
    {% endcache %}

Within your engine (not wagon), this will make a call to

    Rails.cache.fetch("locomotive/key1/key2/key3")

If there is a cache hit, the found content will be returned and rendered.
If there is a miss, the block inside the `{% cache %}` tag will be executed,
and the result will be written to the cache before the content is
rendered.

Your LocomotiveCMS engine must be configured to use a
memcache-equivalent datastore through the dalli gem in order for
this to work. Otherwise it will count as a cache miss every time. Check your Rails logs to
watch cache misses vs. hits as well as composite keys being used.

**Note:** Cache must currently be manually reset on your engine through
`irb` by executing `Rails.cache.clear` after any changes to contents.


### send_email

#### Description

Send an email directly from a liquid template. Although, it does break the MVC pattern, it is reasonable to use it within a LocomotiveCMS site for simple needs.

The emails are sent by [Pony](https://github.com/benprew/pony). It is disabled in Wagon, only the logs are output.

By default, email sending is html-formatted. You can disable this behaviour by setting the **html** attribute to false.

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

It is also possible to attach a file to the email.

You can pass directly some text:

    {% send_email to: params.email, from: 'me@locomotivecms.com', subject: 'Hello world', page_handle: 'email-template', smtp_address: 'smtp.example.com', smtp_user_name: 'user', smtp_password: 'password', attachment_name: 'my_file.txt', attachment_value: 'hello world' %}{% endsend_email %}

Or an url, or even, a path to a local file:

    {% send_email to: params.email, from: 'me@locomotivecms.com', subject: 'Hello world', page_handle: 'email-template', smtp_address: 'smtp.example.com', smtp_user_name: 'user', smtp_password: 'password', attachment_name: 'my_file.txt', attachment_value: '/somewhere/test.txt' %}{% endsend_email %}

Note: An attachment's mime-type is set based on the filename (as dictated by the ruby gem mime-types). So 'foo.pdf' has a mime-type of 'application/pdf'

### facebook_posts ###

#### Description ####

Display the posts of a Facebook account. The Liquid code inside the **facebook_posts** tag will be used as the template to display a single Facebook post.

A liquid variable named **facebook_post** is available inside. It contains the following attributes representing a Facebook post.
  - name
  - message
  - picture
  - link
  - created_time

#### Usage ####

    <ul>
      {% facebook_posts account: 'my_account', access_token: 'my access token', limit: 10 %}
        <li>
          <a href="{{ facebook_post.link }}">{{ facebook_post.name }}</a>
          <br/>
          Posted on {{ facebook_post.created_time | date: "%a, %d %b %Y" }}
        </li>
      {% endfacebook_posts %}
    </ul>

### create

#### Description

Create a new entry for any content types of the current site. Again, it does break the MVC pattern, so use it wisely.

#### Usage

    {% create 'projects', title: 'Your new title' %}
    <p>The project {{ project.title }} was created with success</p>
    {% else %}
    <p>Arrggh, there was an error.</p>
    {% endupdate %}

Note: The whole context of the page is available in the 2 blocks.


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

    gem 'locomotivecms_liquid_extensions', github: 'locomotivecms/liquid_extensions', branch: 'hosting'


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

Copyright (c) 2014 NoCoffee, released under the MIT license
