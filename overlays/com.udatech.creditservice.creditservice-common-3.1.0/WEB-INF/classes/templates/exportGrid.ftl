<a href="javascript:void(0);" onclick="exportData('${gridId}','${exportType}','${getAllUrl}');" class="btn btn-default btn-sm"><i class="fa fa-share"></i> 导出</a>
<div style="display: none">
    <form id="ablg" action="${exportUrl}" method="post">
        <input type="hidden" name="excelField" id="excelField"></input>
        <input type="hidden" name="excelValues" id="excelValues"></input>
        <input type="hidden" name="titleArr" id="titleArr"></input>
        <input type="hidden" name="fieldArr" id="fieldArr"></input>
    </form>
</div>