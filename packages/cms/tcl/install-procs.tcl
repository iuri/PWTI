ad_library {
    install callbacks
}
namespace eval cms::install {}
ad_proc -public cms::install::package_instantiate { -package_id } {
    Procedures to run on package instantiation
} {
    cm::modules::install::create_modules -package_id $package_id
}

ad_proc -public cms::install::package_uninstantiate { -package_id } {
    Procedures to run on package uninstantiation
} {
    cm::modules::install::delete_modules -package_id $package_id
}
