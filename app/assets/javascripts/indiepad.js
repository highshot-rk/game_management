/* INDIEPAD - Developed for indiexpo */

window.WebSocket = window.WebSocket || window.MozWebSocket;


/** Indiepad Class Object
 * @description: Configure and connect to the WebSocket server
 * @param {HashMap} settings
 */

function Indiepad(settings) {
    var self = this;
    this.__connectedPads = 0;

    // Define the settings
    if (!settings) settings = {};

    //this.debug = settings.debug || false;
    this.debug = true;
    this.domain = settings.domain || "indiexpo.net";
    this.server = settings.server || "ws://127.0.0.1:1337";
    this.iframe = settings.iframe || "play_online_iframe";
    this.qrcodeContainer = settings.qrcodeContainer || "indiepad";
    this.qrcode = settings.qrcode || "QRCODE";
    this.onActivate = settings.onActivate || function() {};
    this.storageSessionKey = settings.storageSessionKey || "indiepadSessionID";

    // Old keymapping object (FOR RETRO-COMPATIBILITY PURPOSES)
    this.KEYMAP_OLD = {
        37: "ArrowLeft",
        38: "ArrowUp",
        39: "ArrowRight",
        40: "ArrowDown",
        90: "KeyZ",
        88: "KeyX",
        27: "Escape",
        46: "Delete"
    };

    // Keyboard mapping for each player
    this.KEYMAP = settings.keymap || {
        0: [ // Player 1
            [37, "ArrowLeft"],
            [38, "ArrowUp"],
            [39, "ArrowRight"],
            [40, "ArrowDown"],
            [90, "KeyZ"],
            [88, "KeyX"],
            [27, "Escape"],
            [46, "Delete"]
        ],

        1: [ // Player 2
            [65, "KeyA"],
            [87, "KeyW"],
            [68, "KeyD"],
            [83, "KeyS"],
            [71, "KeyG"],
            [72, "KeyH"],
            [13, "Enter"],
            [46, "Delete"]
        ]
    };

    // Override the document domain and get the iframe references
    document.domain = this.domain;
    var iframe = this.iframe = document.getElementById(this.iframe);

    var _connectWS = function() {
        // Connect to the WebSocket server
        var connection = self.connection = new window.WebSocket(self.server);

        connection.onopen = function() {
            // Connection is opened and ready to use
            if (self.debug) console.log("[INDIEPAD] WebSocket connection established");
        };

        // An error occurred when sending/receiving data
        connection.onerror = console.error;

        // WS connection closed
        connection.onclose = function() {
            connection = null;
            if (self.debug) console.log("[INDIEPAD] Connection closed with the WebSocket server. Trying to reconnect in 5 seconds...");
            setTimeout(_connectWS, 5000);
        };

        connection.onmessage = function(message) {
            try {
                var data = JSON.parse(message.data);
            } catch (err) {
                console.error("[INDIEPAD] This doesn't look like a valid JSON: ", message.data);
                return console.error(err);
            }

            // Handle incoming message
            switch (data.command || data.c) {
                case "QR": // Open the QRCode container to join other pads
                    document.getElementById(self.qrcodeContainer).style.display = "block";

                    qrCode = document.getElementById(self.qrcode).innerHTML;
                    if (qrCode === "") _generateQRCode(self);
                break;

                case "HELLO": // Welcome from the WS server with the session ID
                    // {id: SessionID}

                    self.sessionID = localStorage.getItem(self.storageSessionKey) || data.id;
                    localStorage.setItem(self.storageSessionKey, self.sessionID);

                    // Send the confirmation message to the WS server
                    connection.send(JSON.stringify({
                        command: "HELLO",
                        clientType: "GAME",
                        sessionID: self.sessionID
                    }));
                break;

                case "CHECK_SESSION":
                    // {new: isNewSession}

                    if (self.debug) console.log("[INDIEPAD] Connected to a new session: " + data.new);

                    // Generate the QR code and show it only when a new session has been created
                    if (data.new) {
                        if (self.qrcode) _generateQRCode(self);

                        // Execute the 'onConnect' callback, passing the session ID
                        if (settings.onConnect)
                            settings.onConnect(self.sessionID);
                    }
                break;

                case "D":
                    // {k: keyID, p: playerID}

                    if (self.debug) console.log("[INDIEPAD] Triggered the KEYDOWN event using the " + data.k + " key");
                    self.trigger("keydown", data.k, data.p);
                break;

                case "U":
                    // {k: keyID, p: playerID}

                    if (self.debug) console.log("[INDIEPAD] Triggered the KEYUP event using the " + data.k + " key");
                    self.trigger("keyup", data.k, data.p);
                break;

                case "HELLOPAD":
                    // {padID: PadSessionID}

                    if (self.debug) console.log("[INDIEPAD] Pad " + data.padID + " connected to the WS server, ready to play this session");
                    self.__connectedPads++;
                    self.onActivate();
                break;

                case "BYEPAD":
                    // {padID: PadSessionID}

                    if (self.debug) console.log("[INDIEPAD] Pad " + data.padID + " disconnected from the WS server");
                    self.__connectedPads--;
                break;

                case "BYESESSION":
                    if (self.debug) console.log("[INDIEPAD] All pads disconnected. Session has been closed from the WS server");
                    localStorage.removeItem(self.storageSessionKey);
                    connection.close();
                break;

                case "CLOSEGAME": // reload the page
                  window.location.reload(false);
                break;
            }
        };
    };

    function _initialize() {
        if (iframe) {
            self.iframeWin = iframe.contentWindow || iframe;
            self.iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
        } else {
            self.iframeWin = window;
            self.iframeDoc = window.document;
        }

        // Get the reference of a specific element in the iframe
        if (settings.iframeElemID)
            self.iframeElem = self.iframeDoc.getElementById(settings.iframeElemID);

        if (self.debug) console.log("[INDIEPAD] Iframe loaded");

        // Connect to the WS server
        _connectWS();
    }

    if (settings.autoInit) {
        _initialize();
    } else {
        iframe.onload = _initialize;
    }

    function _generateQRCode(self) {
        var qrcode = document.getElementById(self.qrcode);
        qrcode.innerHTML = "";

        if (self.debug) console.log("[INDIEPAD] QR CODE data: indiepad" + self.sessionID);

        new QRCode(qrcode, {
            text: "indiepad" + self.sessionID,
            width: 250,
            height: 250
        });

        document.getElementById(self.qrcodeContainer).style.display = "block";
    }
};


/* Method: trigger(event, key)
 * @description: Trigger an event on the window and document of the iframe
 * @param {String} event: The javascript event to trigger (eg. "keydown" or "keyup")
 * @param {Number} keyID: LEFT = 0, UP = 1, RIGHT = 2, DOWN = 3, A = 4, B = 5, ESC = 6, DELETE = 7
 **/

Indiepad.prototype.trigger = function(event, keyID, player) {
    if (!this.iframeWin)
        return console.error("[INDIEPAD] Iframe not loaded yet. Unable to trigger keys");

    if (keyID < 8) {
        var playerKeys = this.KEYMAP[player][keyID];
        var key = playerKeys[0];
        var keyChar = playerKeys[1];
    } else {
        // Retro-compatibility code
        var key = keyID;
        var keyChar = this.KEYMAP_OLD[key];
    }

    var oEvent = new KeyboardEvent(event, {
        keyCode: key,
        which: key,
        code: keyChar,
        key: keyChar
    });

    // Chromium hack
    Object.defineProperty(oEvent, 'keyCode', {
        get: function() {
            return key;
        }
    });

    Object.defineProperty(oEvent, 'which', {
        get: function() {
            return key;
        }
    });

    if (!this.iframeElem) {
        this.iframeWin.dispatchEvent(oEvent);
        this.iframeDoc.dispatchEvent(oEvent);
     } else {
        this.iframeElem.dispatchEvent(oEvent);
    }
};
