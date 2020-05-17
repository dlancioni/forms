<?php

class Filter {

    function __construct() {
    }

    function filter() {

    }


    function getFilter($_REQUEST) {
        // Filter logic	
        if (isset($_REQUEST['id_event'])) {
            if ($_REQUEST['id_event'] == 6) {
                foreach($_REQUEST as $key => $val) {
                    $fieldName = trim($key);
                    $fieldValue = trim($val);
                    if (isValid($fieldName) == "true") {
                        if (strpos($fieldName, "_operator") > 0) {
                            $fieldOperator = $fieldValue;
                            echo $fieldOperator;
                        } else {
                            if (trim($fieldValue) != "" && trim($fieldValue) != "0") {
                                if ($fieldOperator == "0") {$fieldOperator = "=";}
                                $item = ["field_name" => $fieldName, "operator" => $fieldOperator, "field_value" => $fieldValue];
                                array_push($filter, $item);
                            }
                        }
                    }
                }                
            }
        }

        return $filter;
    }

}
?>
