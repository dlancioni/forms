<div class="w3-responsive">
    </br>
    </br>
    <form class="w3-container" id="frm">
        <div class='w3-row-padding'>

            <?php
                //https://www.w3schools.com/w3css/w3css_references.asp
                if ($table) {
                    pg_result_seek($table, 0);                
                    while ($column = pg_fetch_row($table)) {
                        if ($column[FIELD_FK] == 0) {
                            echo "<div class='w3-third'>";
                            echo "<label>{$column[FIELD_LABEL]}</label>";
                            echo "<input class='w3-input w3-border' id='{$column[FIELD_NAME]}' type='text' placeholder=''>";
                            echo "<br>";
                            echo "</div>";
                        } else {
                            echo "<div class='w3-third'>";
                            echo "<label>{$column[FIELD_LABEL]}</label>";
                            echo "<select class='w3-input w3-border' id='{$column[FIELD_NAME]}'>";


                            
                            echo "</select>";
                            echo "<br>";
                            echo "</div>";                            
                        }
                    }
                }
            ?>

        </div>
    </form>
</div>


