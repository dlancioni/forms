<div class="w3-responsive">
    </br>
    </br>
    <form class="w3-container" id="frm">
        <div class='w3-row-padding'>
            <?php
            if ($tableId > 0) {
                echo str_replace('|',"\"",$json->resultset->html);
            }
            ?>
        </div>
    </form>
</div>


