[![CircleCI](https://circleci.com/gh/sul-dlss/cocina-models.svg?style=svg)](https://circleci.com/gh/sul-dlss/cocina-models)
[![Test Coverage](https://api.codeclimate.com/v1/badges/472273351516ac01dce1/test_coverage)](https://codeclimate.com/github/sul-dlss/cocina-models/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/472273351516ac01dce1/maintainability)](https://codeclimate.com/github/sul-dlss/cocina-models/maintainability)
[![Gem Version](https://badge.fury.io/rb/cocina-models.svg)](https://badge.fury.io/rb/cocina-models)
[![OpenAPI Validator](http://validator.swagger.io/validator?url=https://raw.githubusercontent.com/sul-dlss/cocina-models/main/openapi.yml)](http://validator.swagger.io/validator/debug?url=https://raw.githubusercontent.com/sul-dlss/cocina-models/main/openapi.yml)

# Cocina::Models

The cocina-models gem is a Ruby implementation of the Stanford Digital Repository (SDR) data model, which we named "Cocina." The data being modeled is oriented around digital repository objects.

The data model is expressed in an OpenAPI specification that lives in this codebase. Expressing the model in such a spec allows for rich validation (using gems such as `OpenAPIParser` and `committee`). The gem provides a set of generators (see below) to generate Ruby classes from the specification, with modeling provided by dry-struct / dry-types. Together, these provide a way for consumers to validate objects against models and to manipulate those objects.

Note that the data model encodes properties as camelCase, which the team believes to be consistent with other HTTP APIs and the original design of the Cocina data model. While using camelCase in Ruby code may look and feel wrong, we did explore automagic conversion between camelCase in the model and snake_case in the Ruby context. We ultimately concluded that we have enough representations of the data model in enough codebases to reasonably worry about data inconsistency problems, none of which we need in our work on SDR.

## Configuration

Set the PURL url base:
```ruby
Cocina::Models::Mapping::Purl.base_url = Settings.release.purl_base_url
```

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

### Controlled vocabularies
```
exe/generator generate_vocab
```

### Descriptive documentation
```
exe/generator generate_descriptive_docs
```

## Testing

The generator is tested via its output when run against `openapi.yml`, viz., the Cocina model classes. Thus, `generate` should be run after any changes to `openapi.yml`.

Beyond what is necessary to test the generator, the Cocina model classes are not tested, i.e., they are assumed to be as specified in `openapi.yml`.

## Testing validation changes

If there is a possibility that a model or validation change will conflict with some existing objects then [validate-cocina](https://github.com/sul-dlss/dor-services-app/blob/main/bin/validate-cocina) should be used for testing. This must be run on sdr-deploy since it requires deploying a branch of cocina-models.

1. Create a cocina-models branch containing the proposed change and push to Github.
2. On sdr-deploy, check out `main`, update the `Gemfile` so that cocina-models references the branch, and `bundle install`.
3. Select the appropriate database.
For QA:
```
export DATABASE_NAME="dor_services"
export DATABASE_USERNAME=$DOR_SERVICES_DB_USER
export DATABASE_HOSTNAME=$DOR_SERVICES_DB_QA_HOST
export DATABASE_PASSWORD=$DOR_SERVICES_DB_QA_PWD
```

For stage:
```
export DATABASE_NAME="dor_services"
export DATABASE_USERNAME=$DOR_SERVICES_DB_USER
export DATABASE_HOSTNAME=$DOR_SERVICES_DB_STAGE_HOST
export DATABASE_PASSWORD=$DOR_SERVICES_DB_STAGE_PWD
```

For production:
```
export DATABASE_NAME="dor_services"
export DATABASE_USERNAME=$DOR_SERVICES_DB_USER
export DATABASE_HOSTNAME=$DOR_SERVICES_DB_PROD_HOST
export DATABASE_PASSWORD=$DOR_SERVICES_DB_PROD_PWD
```

4. Run `bin/validate-cocina`:
```
export RUBYOPT='-W:no-deprecated -W:no-experimental'
RAILS_ENV=production bin/validate-cocina -p 8
```
5. Check `validate-cocina.csv` for validation errors.

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

**NOTE**: You can skip this step if the new release is a patch-level bump only.

Next, you should release versions of [sdr-client](https://github.com/sul-dlss/sdr-client) and [dor-services-client](https://github.com/sul-dlss/dor-services-client/) pinned to this version because applications such as [Argo](https://github.com/sul-dlss/argo) depend on both of these gems using the same models.

### Step 3: Update service API specifications and gems

**NOTE**: You can skip this first half of the step if there have not been any changes to the `cocina-models` OpenAPI spec since the prior release.

The cocina-models gem is used in applications that have an API specification that accepts Cocina models. Next, make sure that the `openapi.yml` for these applications include the `openapi.yml` schema changes made in cocina-models. This list of services is known to include:

* [sul-dlss/sdr-api](https://github.com/sul-dlss/sdr-api)
* [sul-dlss/dor-services-app](https://github.com/sul-dlss/dor-services-app/)

This can be accomplished by copying and pasting these schemas. By convention, these schemas are listed first in the `openapi.yml` of the associated projects, followed by the application-specific schemas.

#### Step 3b: Bump gems

At the same, we have found it convenient to use these PRs to also bump the versions of cocina-models, sdr-client, and dor-services-client in these applications/services. Why? When [dor-services-app](https://github.com/sul-dlss/dor-services-app), for example, is updated to use the new models (via the auto-update script), these clients should be updated at the same time or there is risk of models produced by dor-services-app not being acceptable to the clients.

### Step 4: Update other dependent applications

Once the above listed steps have been completed, all the following applications that use cocina-models should be updated and released at the same time.  "Cocina Level 2" describes this set of updates.

* [sul-dlss/argo](https://github.com/sul-dlss/argo/)
* [sul-dlss/common-accessioning](https://github.com/sul-dlss/common-accessioning/)
* [sul-dlss/dor_indexing_app](https://github.com/sul-dlss/dor_indexing_app/)
* [sul-dlss/google-books](https://github.com/sul-dlss/google-books/)
* [sul-dlss/happy-heron](https://github.com/sul-dlss/happy-heron/)
* [sul-dlss/hydra_etd](https://github.com/sul-dlss/hydra_etd/)
* [sul-dlss/infrastructure-integration-test](https://github.com/sul-dlss/infrastructure-integration-test/)
* [sul-dlss/pre-assembly](https://github.com/sul-dlss/pre-assembly/)

There are scripts to help with this:

#### Step 4A: Create the PRs

There is a Jenkins CI job that you can run manually to create all the PRs you need. Head to https://sul-ci-prod.stanford.edu/job/SUL-DLSS/job/access-update-scripts/job/cocina-level2-updates/ and then click `Build Now`. Click the new build that is created and then `Console Output` to watch the build. Once it has completed, you can proceed with the next step.

If for some reason the above method does not work, the sul-dlss/access-update-scripts repo has a script for this: `cocina_level2_prs.rb`. You will need a github access token with scopes of "read:org" and "repo" (see https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) to run it, as noted in the comments at the top of that script.

#### Step 4B: Merge the PRs

[sul-dlss/access-update-scripts](https://github.com/sul-dlss/access-update-scripts) has a switch in the `merge-all.rb` script for this, as noted in the comments at the top of that script. (`REPOS_PATH=infrastructure GH_ACCESS_TOKEN=abc123 COCINA_LEVEL2= ./merge-all.rb`)

### Step 5: Deploy all affected applications together

[sul-dlss/sdr-deploy](https://github.com/sul-dlss/sdr-deploy) has a flag in the deploy script to limit deploys to cocina dependent applications.  Refer to instructions in the [sdr-deploy/README](https://github.com/sul-dlss/sdr-deploy/blob/main/README.md#only-deploy-repos-related-to-cocina-models-update).

Note that running the integration tests is currently the best way we have to check for unintended effects and/or bugs when rolling out cocina-models changes.

#### Step 5A: Deploy to QA and/or Stage

#### Step 5B: Run infrastructure_integration_tests

It is safest to ensure _all_ the integration tests run cleanly.  However, patch releases of cocina-models may only warrant running individual tests that exercise the changes.

#### Step 5C: Deploy to Production

**[Turn off Google Books](https://sul-gbooks-prod.stanford.edu/features) when deploying to production.** This avoids failed deposit due to a temporary Cocina model mismatch. Unlike other applications, the deposits will fail without retry and require manual remediation.

## Usage conventions

The following are the recommended naming conventions for code using Cocina models:

* `cocina_item`: `Cocina::Models::DRO` instance
* `cocina_agreement`: `Cocina::Models::DRO` with type of Cocina::Models::ObjectType.agreement
* `cocina_admin_policy`: `Cocina::Models::AdminPolicy` instance
* `cocina_collection`: `Cocina::Models::Collection` instance
* `cocina_object`: `Cocina::Models::DRO` or `Cocina::Models::AdminPolicy` or `Cocina::Models::Collection` instance

## RSpec matchers

As of the 0.69.0 release, the `cocina-models` gem provides RSpec matchers for downstream apps to make it easier to compare Cocina data structures. The matchers provided include:

* `equal_cocina_model`: Compare a Cocina JSON string with a model instance. This matcher is especially valuable coupled with the `super_diff` gem (a dependency of `cocina-models` since the 0.69.0 release). Example usage:
  * `expect(http_response_body_with_cocina_json).to equal_cocina_model(cocina_instance)`
* `cocina_object_with` (AKA `match_cocina_object_with`): Compare a Cocina model instance with a hash containining part of the structure of a Cocina object. Example usage:
  * `expect(CocinaObjectStore).to have_received(:save).with(cocina_object_with(access: { view: 'world' }, structural: { contains: [...] }))`
  * `expect(updated_cocina_item).to match_cocina_object_with(structural: { hasMemberOrders: [] })`
* `cocina_object_with_types`: Check a Cocina object's type information. Example usage:
  * `expect(object_client).to have_received(:update).with(params: cocina_object_with_types(content_type: Cocina::Models::ObjectType.book, viewing_direction: 'left-to-right'))`
* `cocina_admin_policy_with_registration_collections`: Check a Cocina admin policy's collections. Example usage:
  * `expect(object_client).to have_received(:update).with(params: cocina_admin_policy_with_registration_collections([collection_id]))`
