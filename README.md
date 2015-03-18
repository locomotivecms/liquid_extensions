# LocomotiveCMS::LiquidExtensions

This gem includes list of useful Liquid blocks, tags and filters which can be all embedded in both **Wagon** and the **LocomotiveCMS engine**.
Behind the scene, it uses Solid to write reliable and consistant liquid code.

For now, it only works best with the edge versions of Wagon and the engine (master branch).

## List of filters

### gravatar_tag

#### Description

Generates an image tag for a [Gravatar](https://en.gravatar.com/). The image properties can be customized.
To generate a Gravatar, only the email address of the user is needed.

#### Usage

Simple usage generating the tag for the default gravatar.

    {{ 'me@example.com' | gravatar_tag }}

    <img src="http://www.gravatar.com/avatar/2e0d5407ce8609047b8255c50405d7b1" alt="Gravatar" class="gravatar" />

Specifying the size.

    {{ 'size@example.com' | gravatar_url: 'size:200' }}

    <img src="http://www.gravatar.com/avatar/7b9bc448398cd7effd62e2d0bad057f7?s=200" alt="Gravatar" class="gravatar" />

Specifying multiple properties.

    {{ 'multiple@example.com' | gravatar_url: 's:100', 'd:mm' }}

    <img src="http://www.gravatar.com/avatar/1c583c45005f83eaae25dd8bb68c4330?s=100&d=mm" alt="Gravatar" class="gravatar" />

See *Usage* for `gravatar_url` for additional usage information.

### gravatar_url

#### Description

Generates a URL for a [Gravatar](https://en.gravatar.com/) image. The image properties can be customized.

#### Usage

Simple usage generating the URL for the default gravatar.

    {{ 'me@example.com' | gravatar_url }}

    http://www.gravatar.com/avatar/2e0d5407ce8609047b8255c50405d7b1

Specifying the size.

    {{ 'size@example.com' | gravatar_url: 'size:200' }}

    http://www.gravatar.com/avatar/7b9bc448398cd7effd62e2d0bad057f7?s=200

Specifying multiple properties.

    {{ 'multiple@example.com' | gravatar_url: 's:100', 'd:mm' }}

    http://www.gravatar.com/avatar/1c583c45005f83eaae25dd8bb68c4330?s=100&d=mm

Available properties are:

* `s` or `size` Width and height of the Gravatar (all images are square). The default is 80.
* `d` or `default` Type of image to use if there's no Gravatar associated with the email address. Valid options are:
    * `404` Return a 404 instead of an image
    * `mm` Mystery man - silhouette of a person
    * `identicon` Geometric pattern
    * `monsterid` Generated 'moster'
    * `wavatar` Generated face with varying background
    * `retro` Pixelated image
    * `blank` Transparent image
* `r` or `rating` Maximum allowed rating of the Gravatar. Valid options are g, pg, r, and x.

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

### md5sum

#### Description

Calculates the md5sum of a string as a string (in hexadecimal).

#### Usage

    {{ "Hello World!" | md5sum }}

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
