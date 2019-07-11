var component;
var button;
var key;
var host;
var mounted;
function setHost(_key, _host, _mounted){
    key = _key
    host = _host
    mounted = _mounted
    console.log("key = " + key + " host = " + host + " mounted = " + mounted)
}
function createServerKeyButton() {
    component = Qt.createComponent("../tlist/TlistServerKeyComponent.qml");
    if(component.status === Component.Error){
        console.log("Error create component: " + component.errorString());
    }
    button = null;
    return finishCreation()
}

function finishCreation(){
    if(key !== null && host !== null && mounted !== null){
        button = component.createObject(serverKeyLayout);
        if(button !== null){
            button.text = key
            button.hostName = host
            button.mounted = mounted
        }else{
            console.log("Error creating server key button")
        }
    }else{
        //Error handling
        console.log("Must set server key, host and mounted before creating the button")
    }
    return button;
}
