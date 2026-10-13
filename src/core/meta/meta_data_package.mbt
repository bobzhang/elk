///|
pub let core_meta_meta_data_ename : String = "metaData"

///|
pub let core_meta_meta_data_ens_uri : String = "http://www.eclipse.org/elk/MetaData"

///|
pub let core_meta_meta_data_ens_prefix : String = "metaData"

///|
pub let core_meta_md_model_classifier_id : Int32 = 0

///|
pub let core_meta_md_bundle_classifier_id : Int32 = 1

///|
pub let core_meta_md_bundle_member_classifier_id : Int32 = 2

///|
pub let core_meta_md_group_or_option_classifier_id : Int32 = 3

///|
pub let core_meta_md_group_classifier_id : Int32 = 4

///|
pub let core_meta_md_option_classifier_id : Int32 = 5

///|
pub let core_meta_md_option_dependency_classifier_id : Int32 = 6

///|
pub let core_meta_md_algorithm_classifier_id : Int32 = 7

///|
pub let core_meta_md_category_classifier_id : Int32 = 8

///|
pub let core_meta_md_option_support_classifier_id : Int32 = 9

///|
pub let core_meta_md_option_target_type_classifier_id : Int32 = 10

///|
pub let core_meta_md_graph_feature_classifier_id : Int32 = 11

///|
pub let core_meta_md_bundle_member_name_feature : String = "MD_BUNDLE_MEMBER__NAME"

///|
pub let core_meta_reference_md_option_dependency_target : String = "MD_OPTION_DEPENDENCY__TARGET"

///|
pub let core_meta_reference_md_option_support_option : String = "MD_OPTION_SUPPORT__OPTION"

///|
pub fn core_meta_meta_data_package_id() -> String {
  core_meta_meta_data_ens_uri
}
