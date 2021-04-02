[![CircleCI](https://circleci.com/gh/sul-dlss/cocina-models.svg?style=svg)](https://circleci.com/gh/sul-dlss/cocina-models)
[![Test Coverage](https://api.codeclimate.com/v1/badges/472273351516ac01dce1/test_coverage)](https://codeclimate.com/github/sul-dlss/cocina-models/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/472273351516ac01dce1/maintainability)](https://codeclimate.com/github/sul-dlss/cocina-models/maintainability)
[![Gem Version](https://badge.fury.io/rb/cocina-models.svg)](https://badge.fury.io/rb/cocina-models)
[![OpenAPI Validator](http://validator.swagger.io/validator?url=https://raw.githubusercontent.com/sul-dlss/cocina-models/main/openapi.yml)](http://validator.swagger.io/validator/debug?url=https://raw.githubusercontent.com/sul-dlss/cocina-models/main/openapi.yml)

# Cocina::Models

This is a Ruby implementation of the SDR data model (named "COCINA"). The data being modeled includes digital repository objects.

Validation is performed by openapi (using OpenAPIParser). Modeling is provided by dry-struct and dry-types. Together, these provide a way for consumers to validate objects against models and to manipulate thos objects.

This is a work in progress that will ultimately implement the full [COCINA data model](http://sul-dlss.github.io/cocina-models/). See also [architecture documentation](https://sul-dlss.github.io/taco-truck/COCINA.html#cocina-data-models--shapes).

## Generate models from openapi.yml

Note that only a small subset of openapi is supported. If you are using a new openapi feature or pattern, verify that the model will be generated as expected.

### All
```
exe/generator generate
```

### Single model
```
exe/generator generate_schema DRO
```

## Testing

The generator is tested via its output when run against `openapi.yml`, viz., the Cocina model classes. Thus, `generate` should be run after any changes to `openapi.yml`.

Beyond what is necessary to test the generator, the Cocina model classes are not tested, i.e., they are assumed to be as specified in `openapi.yml`.

## Releasing

### Step 0: Share intent to change the models

Send a note to `#dlss-infra-chg-mgmt` on Slack to let people know what is changing and when.

### Step 1: Cut the release

The release process is much like any other gem. First bump the version in `lib/cocina/models/version.rb`, and commit the result. Then run:
```
bundle exec rake release
```
which pushes the gem to rubygems.org.  Next write up the release notes: https://github.com/sul-dlss/cocina-models/releases .

### Step 2: Update client gems coupled to the models

Next, you should release versions of [sdr-client](https://github.com/sul-dlss/sdr-client) and [dor-services-client](https://github.com/sul-dlss/dor-services-client/) pinned to this version because applications such as [Argo](https://github.com/sul-dlss/argo) depend on both of these gems using the same models.

### Step 3: Update service API specifications and gems

The cocina-models gem is used in applications that have an API specification that accepts Cocina models. Next, make sure that the `openapi.yml` for these applications include the `openapi.yml` schema changes made in cocina-models. This list of services is known to include:

* [sul-dlss/sdr-api](https://github.com/sul-dlss/sdr-api)
* [sul-dlss/dor-services-app](https://github.com/sul-dlss/dor-services-app/)

This can be accomplished by copying and pasting these schemas. By convention, these schemas are listed first in the `openapi.yml` of the associated projects, followed by the application-specific schemas.

#### Step 3b: Bump gems

At the same, we have found it convenient to use these PRs to also bump the versions of cocina-models, sdr-client, and dor-services-client in these applications/services. Why? When [dor-services-app](https://github.com/sul-dlss/dor-services-app), for example, is updated to use the new models (via the auto-update script), these clients should be updated at the same time or there is risk of models produced by dor-services-app not being acceptable to the clients.

### Step 4: Update other dependent applications

Once the above listed steps have been completed, all the following applications that use cocina-models should be updated and released at the same time:

* [sul-dlss/dor_indexing_app](https://github.com/sul-dlss/dor_indexing_app/)
* [sul-dlss/common-accessioning](https://github.com/sul-dlss/common-accessioning/)
* [sul-dlss/google-books](https://github.com/sul-dlss/google-books/)
* [sul-dlss/argo](https://github.com/sul-dlss/argo/)
* [sul-dlss/pre-assembly](https://github.com/sul-dlss/pre-assembly/)
* [sul-dlss/hydrus](https://github.com/sul-dlss/hydrus/)
* [sul-dlss/happy-heron](https://github.com/sul-dlss/happy-heron/)
* [sul-dlss/infrastructure-integration-test](https://github.com/sul-dlss/infrastructure-integration-test/)

## Usage conventions

The following are the recommended naming conventions for code using Cocina models:

* `cocina_item`: `Cocina::Models::DRO` instance
* `cocina_admin_policy`: `Cocina::Models::AdminPolicy` instance
* `cocina_collection`: `Cocina::Models::Collection` instance
* `cocina_object`: `Cocina::Models::DRO` or `Cocina::Models::AdminPolicy` or `Cocina::Models::Collection` instance
