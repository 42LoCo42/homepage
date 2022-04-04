const logError = (e) => {
	document.getElementById("errors").value += e.toString().replace(/^Error: /, "") + "\n"
	console.log(e)
}

const keyStringToFingerprint = (async (keyString) => {
	try {
		const key = await openpgp.readKey({armoredKey: keyString})
		return key.getFingerprint().replace(/(.{4})/g, "$1 ").toUpperCase()
	} catch(e) {
		logError(e)
	}
	return "Fehler bei der Berechnung"
})

const genkeys = (async () => {
	// generate a nice and small key
	const key = await openpgp.generateKey({
		type: "ecc",
		curve: "curve25519",
		userIds: [{
			name: "PGPTool user",
			email: "pgptool@42loco42.duckdns.org"
		}],
		// we don't encrypt keys, as they are not meant to be used outside of this session
		passphrase: ""
	})

	// fill out our key boxes
	privKeyBox = document.getElementById("privKeyBox")
	pubKeyBox  = document.getElementById("pubKeyBox")
	privKeyBox.value = key.privateKeyArmored
	pubKeyBox.value  = key.publicKeyArmored
	pubKeyBox.style.display = "block"

	// fill out statuses
	privKeyStatus = document.getElementById("privKeyStatus")
	pubKeyStatus  = document.getElementById("pubKeyStatus")
	privKeyStatus.innerHTML = "Erzeugt, aber zur Sicherheit ausgeblendet "
	const toggleHideButton = document.createElement("button")
	toggleHideButton.setAttribute("onclick", "toggleHide()")
	toggleHideButton.innerHTML = "Umschalten"
	privKeyStatus.appendChild(toggleHideButton)
	fingerprint = await keyStringToFingerprint(key.publicKeyArmored)
	pubKeyStatus.innerHTML =
		"Erzeugt. Diesen Schl&uuml;ssel nun an die Gegenstelle senden.<br>"
		+ "Fingerabdruck: " + fingerprint
})

const genPartnerKeyFP = (async () => {
	// get the partner key
	const partnerKeyArmored = document.getElementById("partnerKeyBox").value

	// get fingerprint
	const fingerprint = await keyStringToFingerprint(partnerKeyArmored)

	// the field
	partnerKeyFP = document.getElementById("partnerKeyFP")

	// set id
	partnerKeyFP.innerHTML = "Fingerabdruck: " + fingerprint
})

const toggleHide = () => {
	// must be in this order to catch missing display attribute
	// when the button wasn't pressed beforehand
	privKeyBox = document.getElementById("privKeyBox")
	if(privKeyBox.style.display == "block") {
		privKeyBox.style.display = "none"
	} else {
		privKeyBox.style.display = "block"
	}
}

const encrypt = (async () => {
	try {
		// get armored keys
		const publicKeyArmored  = document.getElementById("partnerKeyBox").value
		const privateKeyArmored = document.getElementById("privKeyBox").value

		// stop if keys are empty
		if(publicKeyArmored == "" || privateKeyArmored == "") {
			return
		}

		// create key objects
		const publicKey = await openpgp.readKey({armoredKey: publicKeyArmored})
		const privateKey = await openpgp.readKey({armoredKey: privateKeyArmored})

		// sign and encrypt
		const encrypted = await openpgp.encrypt({
			message: openpgp.Message.fromText(document.getElementById("sendCleartextBox").value),
			publicKeys: publicKey,
			privateKeys: privateKey
		})

		// write encrypted message
		document.getElementById("sendEncryptedBox").value = encrypted
	} catch(e) {
		logError(e)
	}
})

const decrypt = (async () => {
	try {
		// get armored keys
		const publicKeyArmored  = document.getElementById("partnerKeyBox").value
		const privateKeyArmored = document.getElementById("privKeyBox").value

		// stop if keys are empty
		if(publicKeyArmored == "" || privateKeyArmored == "") {
			return
		}

		// create key objects
		const publicKey = await openpgp.readKey({armoredKey: publicKeyArmored})
		const privateKey = await openpgp.readKey({armoredKey: privateKeyArmored})

		// create message object
		const message = await openpgp.readMessage({
			armoredMessage: document.getElementById("recvEncryptedBox").value
		})

		// decrypt and verify
		const {data: decrypted} = await openpgp.decrypt({
			message,
			publicKeys: publicKey,
			privateKeys: privateKey
		})

		// write decrypted message
		document.getElementById("recvCleartextBox").value = decrypted
	} catch(e) {
		logError(e)
	}
})
