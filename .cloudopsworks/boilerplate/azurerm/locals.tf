##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  region_map = {
    asiapacific        = "apac"
    australiacentral   = "auce"
    australiacentral2  = "auce2"
    australiaeast      = "auea"
    australiasoutheast = "ause"
    austriaeast        = "atea"
    belgiumcentral     = "bece"
    belgiumwest        = "bewe"
    brazilsouth        = "brs"
    brazilsoutheast    = "brse"
    canadacentral      = "cace"
    canadaeast         = "caea"
    centralindia       = "cein"
    centralus          = "cus"
    chilecentral       = "clce"
    eastasia           = "ea"
    eastus             = "eus"
    eastus2            = "eus2"
    francecentral      = "frce"
    francesouth        = "frso"
    germanynorth       = "deno"
    germanywestcentral = "dewc"
    indonesiacentral   = "idce"
    israelcentral      = "ilce"
    italynorth         = "itno"
    japaneast          = "jpea"
    japanwest          = "jpwe"
    koreacentral       = "krce"
    koreasouth         = "krso"
    malaysiawest       = "mywe"
    mexicocentral      = "mxce"
    newzealandnorth    = "nzno"
    northcentralus     = "ncus"
    norwayeast         = "nwea"
    norwaywest         = "nwwe"
    polandcentral      = "plce"
    qatarcentral       = "qace"
    southafricanorth   = "sano"
    southafricawest    = "sawo"
    southcentralus     = "scus"
    southeastasia      = "sea"
    southindia         = "sind"
    spaincentral       = "spce"
    swedencentral      = "sece"
    switzerlandnorth   = "chno"
    switzerlandwest    = "chwe"
    taiwan             = "tw"
    uaecentral         = "uaec"
    uaenorth           = "uaen"
    uksouth            = "uks"
    ukwest             = "ukw"
    westcentralus      = "wcus"
    westindia          = "wind"
    westus             = "wus"
    westus2            = "wus2"
    westus3            = "wus3"
  }
  short_region      = lookup(local.region_map, var.region, "")
  system_name       = local.short_region != "" ? format("%s-%s-%s-%s-%s", lower(var.org.organization_unit), lower(var.org.environment_name), lower(var.org.environment_type), var.spoke_def, local.short_region) : format("%s-%s-%s-%s", lower(var.org.organization_unit), lower(var.org.environment_name), lower(var.org.environment_type), var.spoke_def)
  system_name_short = local.short_region != "" ? format("%s-%s-%s-%s-%s", substr(lower(var.org.organization_unit), 0, 3), substr(lower(var.org.environment_name), 0, 3), substr(lower(replace(var.org.environment_type, "-", "")), 0, 4), var.spoke_def, local.short_region) : format("%s-%s-%s-%s", substr(lower(var.org.organization_unit), 0, 3), substr(lower(var.org.environment_name), 0, 3), substr(lower(replace(var.org.environment_type, "-", "")), 0, 4), var.spoke_def)
  all_tags          = merge(module.tags.locals.common_tags, var.extra_tags)
  secret_store_path = format("/%s/%s/%s", lower(var.org.organization_unit), lower(var.org.environment_name), lower(var.org.environment_type))
}
