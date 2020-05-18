<?php

class Filter {

    function __construct() {
    }

    function getFilter($json) {

        // General declaration
        $filter = [];
        $item = "";
        $fieldName = "";
        $fieldOperator = "";
        $fieldValue = "";
        $jsonUtil = new JsonUtil();        

        // Filter logic	
        if (isset($_REQUEST['id_event'])) {
            if ($_REQUEST['id_event'] == 6) {
                foreach($_REQUEST as $key => $val) {
                    $fieldName = trim($key);
                    $fieldValue = trim($val);
                    if ($this->isValid($fieldName) == "true") {
                        if (isset($_REQUEST[$fieldName . "_operator"])) {
                            $fieldOperator = $_REQUEST[$fieldName . "_operator"];
                        }
                        if (trim($fieldValue) != "" && trim($fieldValue) != "0") {
                            $item = ["field_name" => $fieldName, "operator" => $fieldOperator, "field_value" => $fieldValue];
                            array_push($filter, $item);
                        }
                    }
                }
                $json = $jsonUtil->setFilter($json, $filter);
            }
        }
        return $json;
    }

    // Session related fields are in $_REQUEST too
    // We dont want these fields to be used as filter
    function isValid($item) {

        if (strpos($item, "_operator")) {
            return "false";
        }

        switch ($item) {
            case "id_page":
            case "id_table":
            case "id_event":
            case "page_offset":
                return "false";
            default:
                return "true";    
        }
    }

}
?>
