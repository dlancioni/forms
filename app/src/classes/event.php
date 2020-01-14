<?php    

    /*
     * Developed by David Lancioni - 01/2020
     * Create methods used to manipulate events
     */    
    class Event extends Base {

        /*
         * GetList
         */
        function GetList($form) {

            // Query form name            
            $sql = "";
            $sql .= " select";
            $sql .= " t1.id,";
            $sql .= " t1.label,";
            $sql .= " t3.name form_name,";
            $sql .= " t4.name event_name,";
            $sql .= " t5.name event_type,";
            $sql .= " t6.name function_name,";
            $sql .= " t6.code function_code";
            $sql .= " from tb_event t1";
            $sql .= " inner join tb_company t2 on t1.id_company = t2.id";
            $sql .= " inner join tb_form t3 on t1.id_form = t3.id";
            $sql .= " inner join tb_event_name t4 on t1.id_event = t4.id";
            $sql .= " inner join tb_event_for t5 on t1.id_event_type = t5.id";
            $sql .= " inner join tb_function t6 on t1.id_function = t6.id";
            $sql .= " where t1.id_company = " . $this->getCompany();
            $result = $this->getConnection()->query($sql);

            // Return record
            return $result;
        }

    } // End of class
?>