function validateCode() {
    var codeEle = document.getElementById('code');
    if((codeEle.value==null)||(codeEle.value =="")){
      alert("Xin nhập mã đơn hàng");
      codeEle.focus();
      return false;
    }
    return true;
}

function toggleSelectAll(list, status) {
    var name = "#" + list + " input";
    var name_tr = "#" + list + " tr";
    if (status == "check")
    {
        $$(name).each(function(item) {
        item.checked = true;            
        });

        $$(name_tr).each(function(item) {
           item.addClassName('selected');            
        });
    }
    else    
    {
        $$(name).each(function(item) {
        item.checked = false;            
        });

        $$(name_tr).each(function(item) {
           item.removeClassName('selected');            
        });                        
    }
    return false;
}

function calculateDish(price, quantity, targetCell) {
    q = parseFloat(quantity) || 0;
    target = document.getElementById(targetCell);
    target.firstChild.nodeValue = formatMoney(quantity * price);
}

function checkMax(data, max, targetField) {
    val = parseFloat(data) || 0;
    if(val > max) {
        target = document.getElementById(targetField);
        target.value = max;
    }
}

function checkNumeric(data) {
    if(checkNum(data))
        return data;
    else
        return 0;
}

function sumup() {  
    var total = 0, cell,   row = document.getElementById( 'sumtable' ).rows,   i = row.length - 3,   lastrow = row[i];
    var temp, finalCost=0;
    var totalCell = document.getElementById('total_cost');
    var resultCell = document.getElementById('final_cost'), resultHiddenField = document.getElementById('total_price');
    var discountCell = document.getElementById('discount_percent');
    while(i-- > 1) {   
        cell = row[i].cells; j = cell.length - 1;
        temp = parseFloat( cell[j].firstChild.nodeValue ) || 0;
        total += temp*1000;        
    }
    totalCell.firstChild.nodeValue = formatMoney(total);
    finalCost = total * (1 - parseFloat(discountCell.value)/100);
    resultCell.firstChild.nodeValue = formatMoney(finalCost);
    resultHiddenField.value = finalCost;
}

function updateQuantity(cell, quantity) {
    quantityCell = document.getElementById(cell);
    quantityCell.innerHTML = quantity;
}


function checkNum(data) {      // checks if all characters 
    var valid = "0123456789.";     // are valid numbers or a "."
    var ok = 1; var checktemp;
    for (var i=0; i<data.length; i++) {
        checktemp = "" + data.substring(i, i+1);
    if (valid.indexOf(checktemp) == "-1") return 0; }
    return 1;
}

function formatMoney(amount) { // idea by David Turley
    Num = "" + amount;
    var temp1 = "";
    var temp2 = "";
    var count = 0;
    for (var k = Num.length-1; k >= 0; k--) {
        var oneChar = Num.charAt(k);
        if (count == 3) {
            temp1 += ".";
            temp1 += oneChar;
            count = 1;
            continue;
        }
        else {
            temp1 += oneChar;
            count ++;
        }
    }
    for (var k = temp1.length-1; k >= 0; k--) {
        var oneChar = temp1.charAt(k);
        temp2 += oneChar;
    }
    return temp2;
}