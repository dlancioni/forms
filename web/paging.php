<br>
<center>
<?php
    if ($data) {
        $count = $data[0]->record_count;
        // 1 page, do not show
        if ($count > PAGE_SIZE) {
            $pages = round($count / PAGE_SIZE, 2);
            for ($i=0;$i<+$pages;$i++) {
                $page = $i+1;
                $offset = $i * PAGE_SIZE;
                echo "<a href='index.php?id_layout={$id_layout}&id_table={$id_table}&page_offset={$offset}'> {$page} </a>";
            }
        }
    }
?>
</center>