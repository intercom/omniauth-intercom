## 0.1.0 (2016-05-03)

Features:

  - Omniauth2 basic auth (@Skaelv)

## 0.1.1 (2016-05-03)

Features:

    - Add support for signup (@Skaelv)

## 0.1.2 (2016-06-14)

Features:

    - add support for avatar (thanks @bnorton)

## 0.1.3 (2016-07-26)

Features:

    - allow to pre-populate oauth signup form fields (name, email, app_name) (@Skaelv)

## 0.1.4 (2016-11-21)

Features:

    - update to Gemspec to prevent omniauth-oauth2 version clash. If you relied on the omniauth-oauth2 gemspec dependency version to be 1.2.x for other parts of your app you can add:

          gem 'omniauth-oauth2', '~> 1.2'

      to your Gemfile to set the version back to 1.2.x (@travega)

## 0.1.5 (2017-01-16)

Features:
    - add email_verified check 
    
## 0.1.6 (2017-01-20)

Features:
    - add custom user agent 
    
## 0.1.7 (2017-02-27)

Features:
    - add verify email config
    
## 0.1.8 (2017-03-07)

Features:
    - update config to intercom.com domain