## AutoYaST XML Schema Definition

[![Workflow Status](https://github.com/yast/yast-perl-bindings/workflows/CI/badge.svg?branch=master)](
https://github.com/yast/yast-perl-bindings/actions?query=branch%3Amaster)
[![Jenkins Status](https://ci.opensuse.org/buildStatus/icon?job=yast-yast-perl-bindings-master)](
https://ci.opensuse.org/view/Yast/job/yast-yast-perl-bindings-master/)

This package contains the XML schema definition for AutoYaST.

*Note: Some parts of the schema definition are imported from the respective
YaST modules.*

## Local Build

This package uses the [multibuild OBS feature](
https://openbuildservice.org/help/manuals/obs-user-guide/cha.obs.multibuild.html)
which allows to build several (sub)packages from the same sources.

You can build š packages from the sources:

- `yast2-schema-default` - contains full schema for all YaST packages
- `yast2-schema-micro` - smaller schema for minimized YaST installer,
  this is only used for some specific products
- `yast2-schema` - this is the same as the `yast2-schema-default` but can be used
  in products which do not have any "micro' variant.

To build a specific package locally run these commands:

- `yast2-schema` - `rake osc:build`
- `yast2-schema-default` - `rake "osc:build[-M default]"`
- `yast2-schema-micro` - `rake "osc:build[-M micro]"`
