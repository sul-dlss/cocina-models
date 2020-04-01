[![Build Status](https://travis-ci.com/sul-dlss/cocina-models.svg?branch=master)](https://travis-ci.com/sul-dlss/cocina-models)
[![Test Coverage](https://api.codeclimate.com/v1/badges/472273351516ac01dce1/test_coverage)](https://codeclimate.com/github/sul-dlss/cocina-models/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/472273351516ac01dce1/maintainability)](https://codeclimate.com/github/sul-dlss/cocina-models/maintainability)
[![Gem Version](https://badge.fury.io/rb/cocina-models.svg)](https://badge.fury.io/rb/cocina-models)
[![OpenAPI Validator](http://validator.swagger.io/validator?url=https://raw.githubusercontent.com/sul-dlss/cocina-models/master/openapi.yml)](http://validator.swagger.io/validator/debug?url=https://raw.githubusercontent.com/sul-dlss/cocina-models/master/openapi.yml)

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

## Using this gem

If you are using this gem in an application that has an API that accepts Cocina models (e.g., SDR API, Dor-Services-App), make sure that the `openapi.yml` for the application includes the schemas that match the schemas in this `openapi.yml`.

This can be accomplished by cutting and pasting these schemas. By convention, these schemas are listed first in the `openapi.yml` of the associated projects, followed by the application-specific schemas.
