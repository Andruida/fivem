// copy this code into the developer console on
// https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/

myarr = []
children = document.getElementsByClassName("panel")[0].children
for (let i = 3; i < len; i++) {
    myarr.push({version:children[i].href.substring(67,71) , build: children[i].href.substring(67,112)})
}
var url = URL.createObjectURL(new Blob([JSON.stringify(myarr, null, 4)], {type: "application/json"}))
var a = document.createElement("a")
a.href = url
a.download = "artifacts.json"
document.body.appendChild(a);
a.click();
setTimeout(function() {
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);  
}, 0); 