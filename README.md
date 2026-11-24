# WMO S-411 Dynamic Ice Information Product Specification

[![Build Status](https://github.com/metanorma/S-411-Product-Specification/actions/workflows/generate.yml/badge.svg)](https://github.com/metanorma/S-411-Product-Specification/actions/workflows/generate.yml)

This is the WMO repository for developing the next edition of
the S-411 Dynamic Ice Information Products.

S-411 is an [IHO S-100](https://iho.int/en/s-100-based-product-specifications)
based product specification published by the World Meteorological
Organization (WMO) in conjunction with the International Hydrographic
Organization (IHO). Specification changes are coordinated by the WMO
Services Commission (SERCOM) through its Standing Committee on Marine
Meteorological and Oceanographic Services (SC-MMO).

WARNING: The contents of this repository are in draft form and are not necessarily in force yet.
Please refer to the final version published on the official
[GI Registry](https://registry.iho.int) website.


## General

This repository contains the source files of S-411, including:

* S-411 1.2.1 Ice Information Product Specification (`PS/`)
* S-411 1.2.0 Ice Information Data Classification and Encoding Guide (`DCEG/`)

These documents are encoded in the
[Metanorma AsciiDoc format](https://www.metanorma.org/author/topics/document-format/).

Publication identifiers:

| Document | Identifier | URN |
| --- | --- | --- |
| Ice Information Product Specification | S-411 (ed 1.2.1) | `urn:mrn:wmo:pub:s-411:ed1.2.1` |
| Data Classification and Encoding Guide | S-411 Annex A (ed 1.2.0) | `urn:mrn:wmo:pub:s-411:annex-a:ed1.2.0` |


## Structure

* `sources/1.2.1/` — source of the S-411 documents and models:
  * `PS/` — Ice Information Product Specification
  * `DCEG/` — Ice Information Data Classification and Encoding Guide
  * `FC/` — S-411 Feature Catalogue
  * `PC/` — S-411 Portrayal Catalogue
  * `GML/` — S-411 GML schema
  * `model/` — S-411 UML model
  * `samples/` — sample S-411 datasets
* `original/S-411_annexes/` — original S-411 annexes (schemas, portrayal, examples, test data)
* `Python/` — tools for SIGRID-3 to S-411 conversion


## Usage

This repository uses `metanorma` to run these processes.

Please refer to
[Metanorma-IHO documentation](https://www.metanorma.org/author/iho/authoring-guide/)
for authoring guidance.


## Installing build tools

See the [Metanorma install](https://www.metanorma.org/install/) page.


## Building the document

If you have installed the build tools locally, and wish to run the
locally-installed compilation tools, there is nothing further to set.

If you use a locally installed Metanorma, run:

```sh
metanorma site generate
```

The documents render through the `wmo` flavor of
[metanorma-taste](https://github.com/metanorma/metanorma-taste): the
product specification carries the technical-publication cover, the
DCEG the guideline cover, and the inner pages follow the WMO
publication typography.

If you wish to avoid using local dependencies, use the docker
version by:

```sh
docker run -v "$(pwd)":/metanorma -w /metanorma -it metanorma/mn metanorma site generate
```
