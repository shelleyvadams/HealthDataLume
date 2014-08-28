/**
 * @file HealthDataLume.js
 * @author Shelley V. Adams 
 * @copyright 2014 Shelley V. Adams
 * @license MIT License
 * @description HealthDataLume.js requires [Bootstrap]{@link http://getbootstrap.com/} v3.x and [jQuery]{@link http://jquery.com/} v1.11 or higher.
**/

/**
 * @class HealthDataLume
 * @static
 * @description Top-level application.
 * @param {Document} doc
**/
var HealthDataLume = (function(doc) {
	/**
	 * @constant
	 * @type {String}
	 * @memberof HealthDataLume
	 * @private
	 * @description Path to default XSL.
	**/
	var XSL_FILE = "health_data_lume.xsl";

	/**
	 * @member xsltProcessor
	 * @type {XSLTProcessor}
	 * @memberof HealthDataLume
	 * @private
	**/
	var xsltProcessor = new XSLTProcessor();

	/**
	 * @member parser
	 * @type {DOMParser}
	 * @memberof HealthDataLume
	 * @private
	 * @description Used to parse XML from a String
	**/
	var parser = new DOMParser();

	/**
	 * @member sampleBrowser
	 * @type {GitHubBrowser}
	 * @memberof HealthDataLume
	 * @private
	**/
	var sampleBrowser = null;

	/**
	 * @function errorIssueLink
	 * @memberof HealthDataLume
	 * @private
	 * @param {String} [customText]
	 * @returns {String} HTML for an anchor element
	 * @description Build a link to the project's issue page at GitHub.
	**/
	var errorIssueLink = function(customText) {
		var linkText = customText || "report an issue";
		return "<a class='alert-link' href='https://github.com/shelleyvadams/HealthDataLume/issues'>" + linkText + "</a>";
	}

	/**
	 * @function errorAlert
	 * @memberof HealthDataLume
	 * @private
	 * @param {Error} err
	 * @returns {String} HTML for a div element
	 * @description Build a Bootstrap dismissible alert (danger) containing an error message.
	**/
	var errorAlert = function(err) {
		return "<div class='alert alert-danger alert-dismissible' role='alert'>\n<button type='button' class='close' data-dismiss='alert'><span aria-hidden='true'>&times;</span><span class='sr-only'>Close</span></button>\n" +
		err +
		"\n</div>\n";
	}

	/**
	 * function localISODate
	 * @memberof HealthDataLume
	 * @private
	 * @description There's gotta be an easier way, but I haven't found it yet.
	 **/
	var localISODate = function() {

		var tsDate = new Date();
		var dateNumFormat = new Intl.NumberFormat("en", {minimumIntegerDigits: 2});

		var tzHrs = parseInt(tsDate.getHours(),10) - parseInt(tsDate.getUTCHours(),10);

		return (
			tsDate.getFullYear() + "-" +
			dateNumFormat.format(parseInt(tsDate.getMonth(),10)+1) + "-"
			+ dateNumFormat.format(parseInt(tsDate.getDate(),10)) + "T" +
			tsDate.toLocaleTimeString("en", {hour12: false}) +
			(tzHrs < 0 ? "" : "+" ) + dateNumFormat.format(tzHrs) + ":00"
		);
	};

	/**
	 * @function getXSL
	 * @memberof HealthDataLume
	 * @private
	 * @see [Synchronous and asynchronous requests]{@link https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Synchronous_and_Asynchronous_Requests} at Mozilla Developer Network
	 * @description Load the default XSL stylesheet
	**/
	var getXSL = function() {

		/**
		 * @function loadXSL
		 * @memberof getXSL
		 * @private
		 * @this xhReq
		 * @param {Document} xslDoc - Reference to an object to hold the Document object in XMLHttpRequest.responseXML
		**/
		var loadXSL = function(xslDoc) {
			xslDoc = this.responseXML;
			try {
				xsltProcessor.importStylesheet(xslDoc);
			} catch (xslErr) {
				throw "<strong>Yikes!</strong> Something is wrong with the XSL stylesheet.\n" + xslErr;
			}
		}

		/**
		 * @function xhrSuccess
		 * @memberof getXSL
		 * @private
		 * @this xhReq
		 * @description Apply the callback function (loadXSL)
		**/
		var xhrSuccess = function() {
			this.callback.apply(this, this.arguments);
		}

		/**
		 * @function xhrError
		 * @memberof getXSL
		 * @private
		 * @this xhReq
		 * @throws {Error} The HTTP request should return a status of "200 OK" anything else is an error.
		**/
		var xhrError = function() {
			throw new Error( "<strong>Uh oh!</strong> Unable to load XSL formatting instructions. Try refreshing the page. If the problem persists, " + errorIssueLink() + " noting that the server said: <q>" + this.statusText + "</q>.");
		};

		var xhReq = new XMLHttpRequest();
		xhReq.callback = loadXSL;
		xhReq.arguments = arguments;
		xhReq.onload = xhrSuccess;
		xhReq.onerror = xhrError;
		xhReq.open("get", XSL_FILE, true);
		xhReq.send(null);
	}

	/**
	 * @function getFile
	 * @memberof HealthDataLume
	 * @private
	 * @param {HTMLInputElement} input - File input element
	 * @param {HTMLInputElement} display - Read-only text input element to display the name of the selected file
	 * @param {jQuery} fileContent
	 * @throws {Error} The selected file must have an XML media type within "text/*" or "application/*"
	 * @description Get the XML file selected by the user.
	**/
	var getFile = function(input, display, fileContent) {
		display.val("");
		var userFile = input.get(0).files.item(0);
		if ( userFile.type.search(/(?:text|application)\/(?:\w[\w\.\-]+\+)?xml/) >= 0 ) {
			display.val(userFile.name);
		} else {
			throw new Error("<strong>Oops!</strong> HealthDataLume only understands XML files." + (userFile.name.length > 0 ? " If you're sure that <tt>" + userFile.name + "</tt> is an XML file, please " + errorIssueLink() + "." : ""));
		}

		var xmlReader = getXMLReader(fileContent);
		xmlReader.readAsText(userFile);

	};

	/**
	 * @function getXMLReader
	 * @memberof HealthDataLume
	 * @private
	 * @param {jQuery} contentInputElement
	 * @returns {FileReader}
	 * @throws {Error} The selected file must be readable.
	 * @description Setup the FileReader responsible for fetching the user's XML file.
	**/
	var getXMLReader = function(contentInputElement) {
		var readIt = new FileReader();
		readIt.onerror = (function() {
			return function(e) {
				throw new Error("<strong>Shoot!</strong> Couldn't load your file.");
			};
		})();
		readIt.onload = ( function(contentInEle) {
			return function(e) {
				contentInEle.val(e.target.result);
				contentInEle.change();
			};
		})(contentInputElement);
		return readIt;
	};

	/**
	 * @function transformXML
	 * @memberof HealthDataLume
	 * @private
	 * @param {jQuery} errContainer - Parent element for any error alerts
	 * @param {String} filename
	 * @param {jQuery} contentInputElement
	 * @param {Document} parentDoc
	**/
	var transformXML = function(errContainer, filename, contentInputElement, parentDoc) {
		try {
			var xmlDoc = parser.parseFromString(contentInputElement.val(), "application/xml");
			if (xmlDoc.documentElement.tagName == "parsererror") {
				throw new ParserError(xmlDoc);
			} else {
				var outputSection = $("#output"),
					result;
				xsltProcessor.clearParameters(); // just in case
				xsltProcessor.setParameter(null, "sourceFilePath", filename);
				xsltProcessor.setParameter(null, "timestamp", localISODate());
				try {
					result = xsltProcessor.transformToFragment(xmlDoc, parentDoc);
				} catch (transformErr) {
					throw "<strong>Uh oh!</strong> Transformation failed.\n" + transformErr;
				}
				try {
					outputSection.removeClass("hidden").html(result);
				} catch(wtfErr) {
					throw "<strong>Boo!</strong> Something went wrong.<br/>\r" + wtfErr;
				}
			}
		} catch (err) {
			errContainer.append( errorAlert(err) );
		}
	}


	// Initialize stuff.
	$(doc).ready(function() {
		var xmlStatus = $("#xml_status");
		var fileInput = $("#xml_file").val("");
		var fileDisplay = $("#file_path").val("");
		var recordContent = $("#xml_string").val("");

		try {
			getXSL();
		} catch (err) {
			$("#health_data_lume").prepend( errorAlert(err) );
		}

		HelpBalloons.applyAllBalloons();
		$("#help_button").on("click", HelpBalloons.toggle);

		$("#reset_button").on("click", function(e){
			xmlStatus.empty();
			$("#output").addClass("hidden").empty();
		});

		$("#open_file").on("click", function(e) {
			fileInput.trigger("click");
		});
		
		$("#samples_button").on("click", function(e) {
			if (sampleBrowser === null) {
				sampleBrowser = new GitHubBrowser(fileDisplay, recordContent);
			}
			if ( !sampleBrowser.isLoaded() ) {
				sampleBrowser.load();
			} else {
				sampleBrowser.modal.modal('show');
			}
		});

		fileInput.change(function(e) {
			try {
				getFile(fileInput, fileDisplay, recordContent);
			} catch (err) {
				xmlStatus.append( errorAlert(err) );
			}
		});

		recordContent.change(function(e) {
			xmlStatus.empty();
			$("#output").empty();
			try {
				transformXML(xmlStatus, fileDisplay.val(), recordContent, doc);
			} catch (err) {
				xmlStatus.append( errorAlert(err) );
			}
		});
	});

})(document);



/**
 * @class HelpBalloons
 * @static
 * @description Handles [Bootstap popovers]{@link http://getbootstrap.com/javascript/#popovers} for displaying help.
 * @todo Tenative: methods to add/destroy a help balloon.
**/
var HelpBalloons = (function() {
	/**
	 * @constant
	 * @type {String}
	 * @memberof HelpBalloons
	 * @private
	 * @description HTML class indicating an element has a popover help balloon.
	**/
	var HELP_CLASS = "popover-help";

	/**
	 * @member
	 * @type {Object}
	 * @memberof HelpBalloons
	 * @private
	 * @description Key-value pairs associating a selector (ideally an id) and an Object containing [Bootstrap popover options]{@link http://getbootstrap.com/javascript/#popovers-usage}.
	**/
	var balloons = {
		"#help_button": {
			container: "body",
			placement: "left",
			content: "Toggle help balloons.",
			trigger: "manual"
		},
		"#open_file": {
			container: "body",
			html: true,
			placement: "bottom",
			content: "Open a locally stored <abbr title='Clinical Document Architecture, Release 2'>CDA R2</abbr> or <abbr title='Consolidated Clinical Document Architecture'>C-CDA</abbr> file.",
			trigger: "manual"
		},
		"#file_path": {
			container: "body",
			html: true,
			placement: "top",
			content: "Name of current file, if any.",
			trigger: "manual"
		},
		"#samples_button": {
			container: "body",
			html: true,
			placement: "right",
			title: "Under construction.",
			content: "Browse <a href='https://github.com/chb/sample_ccdas' target='_blank'>sample <abbr title='Consolidated Clinical Document Architecture'>C-CDA</abbr> files on GitHub</a> and select one to view with HealthDataLume.",
			trigger: "manual"
		},
		"#reset_button": {
			container: "body",
			placement: "left",
			content: "Start over. Clear file selection and any output.",
			trigger: "manual"
		},
		"#output": {
			container: "section",
			placement: "bottom",
			content: "HealthDataLume's output from the selected file.",
			trigger: "manual"
		}
	};

	/**
	 * @function applyBalloon
	 * @memberof HelpBalloons
	 * @private
	 * @static
	 * @param {String} selector
	**/
	var applyBalloon = function(selector){
		var ele = $(selector);
		ele.popover(balloons[selector]);
		ele.addClass(HELP_CLASS);
	};

	return {
	/**
	 * @function applyAllBalloons
	 * @memberof HelpBalloons
	 * @static
	 * @public
	**/
	applyAllBalloons: function() {
		for (var key in balloons) {
			applyBalloon(key);
		}
	},

	/**
	 * @function toggle
	 * @memberof HelpBalloons
	 * @static
	 * @public
	 * @param {Event} e
	**/
	toggle: function(e) {
		e.preventDefault();
		$("." + HELP_CLASS).popover("toggle");
	}

	};
})();



/** When given an invalid XML document, The {@link DOMParser} [implementation in Mozilla Gecko]{@link https://developer.mozilla.org/en-US/docs/Web/API/DOMParser#Error_handling} does not throw an {@link Error}, but returns an {@link XMLDocument} with `parsererror` as its {@link Document.documentElement}.
 * @constructor
 * @public
 * @augments Error
 * @param {XMLDocument} xmlDoc - Returned by {@link DOMParser}
 * @see https://bugzilla.mozilla.org/show_bug.cgi?id=45566
**/
function ParserError(xmlDoc) {
	var serializer = new XMLSerializer();
	this.message = "<strong>Dang!</strong> Looks like that wasn't valid XML." + (xmlDoc.documentElement.textContent.length > 0 ? "\n<details class='errorDetails clearfix'>\n<summary class='pull-right'><button type='button' data-toggle='collapse' class='btn btn-default' data-target='#parsererror'>Developer details</button></summary>\n<pre id='parsererror' class='collapse'>" + serializer.serializeToString(xmlDoc) + "</pre>\n</details>\n" : "");
}

/**
 * @memberof ParserError
 * @type {String}
 * @static
 * @public
**/
ParserError.name = "ParserError";
ParserError.prototype = Object.create(Error.prototype);
ParserError.prototype.constructor = ParserError;



/** Get a sparkling new GitHubBrowser object
 * @constructor
 * @param {jQuery} filenameDisplay
 * @param {jQuery} fileContentElement
 * @property {Object} target
 * @property {jQuery} target.display
 * @property {jQuery} target.content
 * @property {ModalDialog} modal - The Bootstrap modal dialog containing this browser.
 * @property {Object} controls - A pile of {@link jQuery}s
 * @property {jQuery} controls.heading - The repository name (linked) goes here (HTMLHeadingElement).
 * @property {jQuery} controls.repoInfo - (HTMLDivElement).
 * @property {jQuery} controls.listingTable - HTMLTableElement.
 * @property {jQuery} controls.listing - The `<tbody>` element that gets populated with file info (HTMLTableSectionElement).
 * @property {jQuery} controls.navPath - Displays current location in the directory tree (HTMLOutputElement)
 * @property {jQuery} backButton - Allow users to make U-turns (HTMLButtonElement).
 * @property {Gh3.User} user - The repository owner, dressed up in an API object.
 * @property {Gh3.Repository} repository - The indicated repository, with API object superpowers.
 * @property {Gh3.Branch} branch - The active branch of this repository.
 * @property {Array} history - Navigation stack (i.e., `push` and `pop`). API objects as breadcrumbs.
 * @property {Boolean} loaded - Has this repository branch been loaded in the browser?
 * @property {RegExp} filenameRegex - Files (not directories) with names matching this pattern will be clickable.
**/
function GitHubBrowser(filenameDisplay, fileContentElement) {
	this.target = {};
	this.target.display = filenameDisplay;
	this.target.content = fileContentElement;
	this.modal = $("#github_samples");
	this.controls = {};
	this.controls.heading = this.modal.find("#github_repo");
	this.controls.repoInfo = this.modal.find(".panel-body");
	this.controls.listingTable = this.modal.find("table");
	this.controls.listing = this.controls.listingTable.find("tbody");
	this.controls.navPath = this.controls.listingTable.find("caption>output");
	this.backButton = $("#github_backnav");
	this.user = new Gh3.User("chb");
	this.repository = new Gh3.Repository("sample_ccdas", this.user);
	this.branch = null;
	this.history = new Array();
	this.loaded = false;
	this.filenameRegex = /.*\.xml$/i;
	console.log("I got a GitHubBrowser!");
}

/** Default value for the {@link HTMLAnchorElement.target} attribute of links to external locations.
 * @memberof GitHubBrowser
 * @constant
 * @public
 * @type {String}
**/
GitHubBrowser.LINK_TARGET = "_blank";

/**
 * @memberof GitHubBrowser
 * @constant
 * @public
 * @type {String}
**/
GitHubBrowser.MASTER_BRANCH = "master";

/**
 * @memberof GitHubBrowser
 * @constant
 * @public
 * @type {String}
**/
GitHubBrowser.GO_TOP_ICON = "fa-home";

/**
 * @memberof GitHubBrowser
 * @constant
 * @public
 * @type {String}
**/
GitHubBrowser.GO_TOP_TEXT = "Go to top level";

/**
 * @memberof GitHubBrowser
 * @constant
 * @public
 * @type {String}
**/
GitHubBrowser.GO_UP_ICON = "fa-arrow-circle-up";

/**
 * @memberof GitHubBrowser
 * @constant
 * @public
 * @type {String}
**/
GitHubBrowser.GO_UP_TEXT = "Go up one level";

/**
 * @memberof GitHubBrowser
 * @constant
 * @public
 * @type {String}
**/
GitHubBrowser.FILE_ICON = "fa-file-o";

/**
 * @memberof GitHubBrowser
 * @constant
 * @public
 * @type {String}
**/
GitHubBrowser.FILE_WRONG_TYPE_ICON = "fa-file";

/**
 * @memberof GitHubBrowser
 * @constant
 * @public
 * @type {String}
**/
GitHubBrowser.DIRECTORY_ICON = "fa-folder-o";

/** Check whether this repository branch has been loaded in the browser 
 * @memberof GitHubBrowser
 * @method
 * @public
 * @returns {Boolean}
**/
GitHubBrowser.prototype.isLoaded = function() {
	return this.loaded;
} // GitHubBrowser.prototype.isLoaded

/** Initial browser load. Fetches information about the repository, its branches, and directory listing for the top level of the specified branch.
 * @memberof GitHubBrowser
 * @method
 * @public
 * @throws GitHubError
**/
GitHubBrowser.prototype.load = function() {

	var fetchBranchContentsCb = function(that) {
		return function (err, res) {
			if(err) {
				throw new GitHubError("Failed to fetch contents of branch: \"" + (that.repository.default_branch || GitHubBrowser.MASTER_BRANCH) + "\".\n" + err);
			} else {
				console.log("Got that branch contents.");
				that.loaded = true;
				that.refreshListing();
				that.modal.modal('show');
			} // else
		};
	} // fetchBranchContentsCb

	var fetchBranchesCb = function(that) {
		return function (err, res) {
			if(err) {
				throw new GitHubError("Failed to fetch branches for repository: \"" + that.repository.name + "\".\n" + err);
			} else { // branches fetched
				console.log("Got that branches.");
				// We're only interested in one.
				that.branch = that.repository.getBranchByName(that.repository.default_branch || GitHubBrowser.MASTER_BRANCH);

				// Make sure it exists.
				if (!that.branch) {
					throw new GitHubError("There is no branch named \"" + (that.repository.default_branch || GitHubBrowser.MASTER_BRANCH) + "\" in the repository \"" + that.repository.name + "\"." );
				} else { // branch exists
					console.log("The branch exists!");

					// Get top-level contents.
					that.branch.fetchContents( fetchBranchContentsCb(that) );

				} //else branch exists
			} // else branches fetched

		}; // function
	} // fetchBranchesCb

	var fetchRepoCb = function(that) {
		return function (err, res) {
			if(err) {
				throw new GitHubError("Failed to fetch repository: \"" + that.repository.name + "\".\n" + err);
			} else { // repository fetched
				console.log("Got that repo.");

				// Add linked repository name to contents.heading
				that.controls.heading.html(
					that.repository.owner.login +
					" / <a href=\"" +
					that.repository.html_url +
					"\"" +
					( that.repository.description && that.repository.description.length > 0 ?
						" title=\"" + that.repository.description + "\"" :
						"") +
					" target=\"" +
					GitHubBrowser.LINK_TARGET +
					"\">" +
					that.repository.name +
					"</a>: " +
					(that.repository.default_branch || GitHubBrowser.MASTER_BRANCH)
				);

				if ( that.repository.description && that.repository.description.length > 0 ) {
					that.controls.repoInfo.prepend(
						"<p><q>" +
						that.repository.description +
						"</q></p>"
					);
				}

				// Get the branches
				that.repository.fetchBranches( fetchBranchesCb(that) );

			} // else repository fetched
		}; // function
	} // fetchRepoCb

	this.repository.fetch( fetchRepoCb(this) );

	// Get the user
	this.user.fetch( (function(that){
		return function (err, res) {
			if(err) {
				throw new GitHubError("Failed to fetch user info.\n" + err);
			} else { // user info fetched
				if (that.user.name && that.user.name.length > 0) {
					that.controls.repoInfo.append(
						"<p>From <a href=\"" +
						( that.user.blog && that.user.blog.length > 0 ? that.user.blog : that.user.html_url ) +
						"\" target=\"" +
						GitHubBrowser.LINK_TARGET +
						"\">" +
						that.user.name +
						"</a>" +
						( that.user.location && that.user.location.length > 0 ? " (" + that.user.location + ")" : "") +
						"</p>"
					);
				}
			}
		}
	})(this) );

} // GitHubBrowser.prototype.load

/** Look at the top item without altering {@link GitHubBrowser.history}.
 * @memberof GitHubBrowser
 * @method
 * @public
 * @returns {Gh3.Dir|Gh3.Branch} The top item on the navigation stack, or -- if the stack is empty -- the branch.
**/
GitHubBrowser.prototype.peek = function() {
	return ( this.history.length > 0 ? this.history[this.history.length - 1] : this.branch );
}

/** Browse to a directory: fetch its contents (only if this is our first visit) and add it to the navigation stack.
 * @memberof GitHubBrowser
 * @method
 * @public
 * @param {Gh3.Dir} ghDir
 * @throws GitHubError
**/
GitHubBrowser.prototype.push = function(ghDir) {
	// Callback for Gh3.Dir.fetchContents
	var fetchDirContentsCb = function(that, dir) {
		return function (err, res) {
			if(err) {
				throw new GitHubError("Failed to fetch contents of directory: \"" + dir.name + "\".\n" + err);
			} else {
				console.log("Got directory contents.");
				that.history.push(dir);
				that.refreshListing();
			} // else
		};
	} // fetchDirContentsCb

	if (!ghDir.getContents()) {
		ghDir.fetchContents ( fetchDirContentsCb(this, ghDir) );
	} else {
		console.log("Been there before.");
		this.history.push(ghDir);
		this.refreshListing();
	}
} // GitHubBrowser.prototype.push

/** Move back one step in the navigation history
 * @memberof GitHubBrowser
 * @method
 * @public
**/
GitHubBrowser.prototype.pop = function() {
	this.history.pop();
	this.refreshListing();
} // GitHubBrowser.prototype.pop

/** Build a the file list for the active directory.
 * @memberof GitHubBrowser
 * @method
 * @public
**/
GitHubBrowser.prototype.refreshListing = function() {

	/****
	***** Build the file listing table content *****
	****/

	var itemArr = this.peek().getContents();

	this.controls.listing.empty().detach();

	for (var i = 0; i < itemArr.length; i++) {
		// begin new table row
		var row = "<tr>";

		// file type
		row += "<td class=\"gh-item-type\"><i class=\"fa fa-fw fa-lg " +
			( itemArr[i].type == "dir" ? GitHubBrowser.DIRECTORY_ICON : GitHubBrowser.FILE_ICON ) +
			"\"></i><span class=\"sr-only\"> " +
			itemArr[i].type +
			"</span></td>";

		// file name (button)
		row += "<td class=\"gh-item-name\"><button type=\"button\" class=\"btn btn-link\" data-item-index=\"" +
			i +
			"\">" +
			itemArr[i].name +
			"</button></td>";

		// file size
		row += "<td class=\"gh-item-size\">" +
			(itemArr[i].size || "--") +
			"</td>";

		// end table row
		row += "</tr>";

		this.controls.listing.append(row);

		row = this.controls.listing.find("tr:last-child");
		var contentButton = row.find("td>button");

		var that = this;
		if (itemArr[i].type == "dir") { // directory stuff
			contentButton.on("click", function(e) {
				that.push(itemArr[$(e.target).data("itemIndex")]);
			});
		} else { // file stuff
			// file clickablity
			if ( !this.filenameRegex || this.filenameRegex.test(itemArr[i].name) ) {
				contentButton.on("click", function(e) {
					that.loadFile(itemArr[$(e.target).data("itemIndex")]);
				});
			} else {
				row.addClass("text-muted");
				row.find("td.gh-item-type>i").removeClass(GitHubBrowser.FILE_ICON).addClass(GitHubBrowser.FILE_WRONG_TYPE_ICON);
				contentButton.prop("disabled", "true");
			}
		} // file stuff
	} // for
	this.controls.listingTable.append(this.controls.listing);

	/****
	***** Update the back-navigation button *****
	****/
	var backIcon = this.backButton.find("i");
	var backText = this.backButton.find(".sr-only");

	if ( this.history.length > 1 ) {
		backIcon.removeClass(GitHubBrowser.GO_TOP_ICON).addClass(GitHubBrowser.GO_UP_ICON);
		backText.text(GitHubBrowser.GO_UP_TEXT);
	} else {
		backIcon.removeClass(GitHubBrowser.GO_UP_ICON).addClass(GitHubBrowser.GO_TOP_ICON);
		backText.text(GitHubBrowser.GO_TOP_TEXT);
	}

	if (this.history.length > 0) {
		this.backButton.prop("disabled", false);
		var that = this;
		this.backButton.off("click");
		this.backButton.on("click", function(e) {
			that.pop();
		});
		this.controls.navPath.text(this.repository.name + ":" + this.branch.name + "/" + this.peek().path);
	} else { // top level of branch
		this.backButton.prop("disabled", "disabled"); // Deactivated. Nowhere to go.
		this.controls.navPath.text(this.repository.name + ":" + this.branch.name);
	} // top level of branch

} // GitHubBrowser.prototype.refreshListing

/** Load the indicated file from GitHub and send it to the target destination.
 * ...and it remembers to close the modal dialog on the way out.
 * @memberof GitHubBrowser
 * @method
 * @public
 * @param {Gh3.File} ghFile - The file to load and send.
 * @throws GitHubError
**/
GitHubBrowser.prototype.loadFile = function(ghFile) {
	// Callback for Gh3.File.fetchContent
	var fetchRawContentCb = function(that, file) {
		return function (err, res) {
			if(err) {
				throw new GitHubError("Failed to fetch raw content of file: \"" + file.name + "\".\n" + err);
			} else {
				console.log("Got raw file content.");
				that.target.display.val(that.repository.name + ":" + that.branch.name + "/" + that.peek().path + "/" + file.name);
				that.target.content.val(file.rawContent);
				that.target.content.change();
			} // else
		};
	} // fetchRawContentCb


	if (!ghFile.getRawContent()) {
		ghFile.fetchContent( fetchRawContentCb(this, ghFile) );
	} else {
		console.log("Seen this before");
	}

	this.modal.modal('hide');
} // GitHubBrowser.prototype.loadFile



/** Specialized error object for when a GitHub API call fails.
 * @constructor
 * @public
 * @augments Error
 * @param {String} [msg]
**/
function GitHubError(msg) {
	this.message = "<strong>Argh!</strong> GitHub\'s octocats are misbehavin\'. " + ( msg && msg.length > 0 ? msg : "outch ..."); // Default nods to k33g's examples
}

/**
 * @memberof GitHubError
 * @static
 * @public
 * @type {String}
**/
GitHubError.name = "GitHubError";
GitHubError.prototype = Object.create(Error.prototype);
GitHubError.prototype.constructor = GitHubError;

