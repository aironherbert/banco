function myFunction() {
    var x = document.getElementById("myDIV");
    if (x.style.display === "none") {
        x.style.display = "block";
    } else {
        x.style.display = "none";
    }
}

function myFunction2() {
    var ini = document.getElementById("ini");
    var fim = document.getElementById("fim");
    var table = document.getElementById("myTable");
    table.innerHTML = '';
    '<%@extratos.reverse_each do |key, value|%>'
    if (Date.parse(ini.value) <= Date.parse('<%=value[:created_at].localtime.strftime("%F %T")%>') && Date.parse(fim.value) >= Date.parse('<%=value[:created_at].localtime.strftime("%F %T")%>')) {
        var row = table.insertRow(table.length);
        var cell1 = row.insertCell(0);
        var cell2 = row.insertCell(1);
        var cell3 = row.insertCell(2);
        var cell4 = row.insertCell(3);
        var cell5 = row.insertCell(4);
        var cell6 = row.insertCell(5);
        cell1.innerHTML = '<%= value[:tipo] %>';
        cell2.innerHTML = '<%= value[:conta_origem] %>';
        cell3.innerHTML = '<%= value[:conta_destino] %>';
        cell4.innerHTML = '<%= value[:valor] %>';
        cell5.innerHTML = '<%= value[:created_at].localtime.strftime("%F %T") %>';
        cell6.innerHTML = '<%= value[:status] %>';
    }
    '<%end%>'
}