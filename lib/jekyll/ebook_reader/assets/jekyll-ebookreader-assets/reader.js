// window.launchEpubJS = launchEpubJS;
// window.handleHypothesisChange = handleHypothesisChange;

function launchEpubJS(bookURL, bookRenderOptions) {
    console.log('launchEpubJS...', bookURL, bookRenderOptions);
    let params = URLSearchParams && new URLSearchParams(document.location.search.substring(1));
    let url = params && params.get("url") && decodeURIComponent(params.get("url"));
    let defaultBookRenderOptions = {
        flow: "scrolled-doc",
        ignoreClass: "annotator-hl",
        width: "100%",
        height: "100%",
        stylesheet: "/assets/books/graeber_debt/epub/assets/epub_iframe_stylesheet.css"
    };


    // Load the opf
    book = ePub(bookURL || url || "https://cdn.hypothes.is/demos/epub/content/moby-dick/book.epub", {
        canonical: function(path) {
            return window.location.origin + window.location.pathname + "?loc=" + path;
        }
    });
    rendition = book.renderTo("viewer", bookRenderOptions || defaultBookRenderOptions);

    // var hash = window.location.hash.slice(2);
    var loc = window.location.href.indexOf("?loc=");
    if (loc > -1) {
        var href = window.location.href.slice(loc + 5);
        var hash = decodeURIComponent(href);
    }

    rendition.display(hash || undefined);


    var next = document.getElementById("next");
    next.addEventListener("click", function(e) {
        rendition.next();
        e.preventDefault();
    }, false);

    var prev = document.getElementById("prev");
    prev.addEventListener("click", function(e) {
        rendition.prev();
        e.preventDefault();
    }, false);

    rendition.on("rendered", function(section) {
        var nextSection = section.next();
        var prevSection = section.prev();

        if (nextSection) {
            nextNav = book.navigation.get(nextSection.href);

            if (nextNav) {
                nextLabel = nextNav.label;
            } else {
                nextLabel = "next";
            }

            next.textContent = nextLabel + " »";
        } else {
            next.textContent = "";
        }

        if (prevSection) {
            prevNav = book.navigation.get(prevSection.href);

            if (prevNav) {
                prevLabel = prevNav.label;
            } else {
                prevLabel = "previous";
            }

            prev.textContent = "« " + prevLabel;
        } else {
            prev.textContent = "";
        }
    });

    var nav = document.getElementById("navigation");
    var opener = document.getElementById("opener");
    opener.addEventListener("click", function(e) {
        if (nav.classList.contains("open")) {
            nav.classList.remove("open")
        } else {
            nav.classList.add("open");
        }
    }, false);

    var closer = document.getElementById("closer");
    closer.addEventListener("click", function(e) {
        nav.classList.remove("open");
    }, false);

    // Hidden
    var hiddenTitle = document.getElementById("hiddenTitle");

    rendition.on("rendered", function(section) {
        var current = book.navigation && book.navigation.get(section.href);

        if (current) {
            document.title = current.label;
        }

        // TODO: this is needed to trigger the hypothesis client
        // to inject into the iframe
        requestAnimationFrame(function() {
            hiddenTitle.textContent = section.href;
        })

        var old = document.querySelectorAll('.active');
        Array.prototype.slice.call(old, 0)
            .forEach(function(link) {
                link.classList.remove("active");
            })

        var active = document.querySelector('a[href="' + section.href + '"]');
        if (active) {
            active.classList.add("active");
        }
        // Add CFI fragment to the history
        history.pushState({}, '', "?loc=" + encodeURIComponent(section.href));
        // window.location.hash = "#/"+section.href
    });

    var keyListener = function(e) {

        // Left Key
        if ((e.keyCode || e.which) == 37) {
            rendition.prev();
        }

        // Right Key
        if ((e.keyCode || e.which) == 39) {
            rendition.next();
        }

    };

    rendition.on("keyup", keyListener);
    document.addEventListener("keyup", keyListener, false);

    book.ready.then(function() {
        var $viewer = document.getElementById("viewer");
        $viewer.classList.remove("loading");
    });

    book.loaded.navigation.then(function(toc) {
        var $nav = document.getElementById("toc"),
            docfrag = document.createDocumentFragment();

        toc.forEach(function(chapter, index) {
            var item = document.createElement("li");
            var link = document.createElement("a");
            link.id = "chap-" + chapter.id;
            link.textContent = chapter.label;
            link.href = chapter.href;
            item.appendChild(link);
            docfrag.appendChild(item);

            link.onclick = function() {
                var url = link.getAttribute("href");
                rendition.display(url);
                return false;
            };

        });

        $nav.appendChild(docfrag);


    });

    book.loaded.metadata.then(function(meta) {
        var $title = document.getElementById("title");
        var $author = document.getElementById("author");
        var $cover = document.getElementById("cover");
        var $nav = document.getElementById('navigation');

        $title.textContent = meta.title;
        $author.textContent = meta.creator;
        if (book.archive) {
            book.archive.createUrl(book.cover)
                .then(function(url) {
                    $cover.src = url;
                })
        } else {
            $cover.src = book.cover;
        }

    });

    book.rendition.hooks.content.register(function(contents, view) {

        contents.window.addEventListener('scrolltorange', function(e) {
            var range = e.detail;
            var cfi = new ePub.CFI(range, contents.cfiBase)
                .toString();
            if (cfi) {
                book.rendition.display(cfi);
            }
            e.preventDefault();
        });

    });

}


function wait(t) {
    return new Promise(function(resolve) {
        window.setTimeout(resolve, t)
    });
}

function handleHypothesisChange(state) {

    let epubjsStyleIfHypoOpen = `body.hypothesis-highlights-always-on { padding-left: 5px !important; }`

    let main = document.querySelector('#ebook-main');
    let hypoWasAlreadyOpen = main.classList.contains('hypoIsOpen');
    let hypoSidebarDidChange = (
        (hypoWasAlreadyOpen && !state.expanded)
        || (!hypoWasAlreadyOpen && state.expanded));
    if (hypoSidebarDidChange) {
        // Wait until epub.js iframe is loaded
        if (!document.querySelector('div.epub-view iframe')) {
            wait(1500)
                .then(
                    (a) => {
                        console.log('waiting...', a);
                        resizeReflowAndScroll();
                    }
                );
        } else {
            resizeReflowAndScroll();
        }
    } else {
        return;
    }

    // Reflow txt to still be visible, scroll to maintain location
    function resizeReflowAndScroll() {
        console.log('reflowing...')

        // Main window
        let currScroll = scrollY;
        let viewer = document.querySelector("#viewer");
        let parsedRenditionWidthPct = Number.parseInt(rendition.settings.width) / 100;

        // Hypothesis
        let hypoSidebar = document.querySelector("hypothesis-sidebar")
            .shadowRoot.querySelector('div.annotator-frame');

        // epub.js iframe
        let iframeEl = document.querySelector('iframe');
        let iframePaddingElement = iframeEl.contentDocument.querySelector("#iframePaddingElement");
        console.log(iframeEl, iframePaddingElement);
        if (!iframePaddingElement) {
            iframePaddingElement = document.createElement("style");
            iframePaddingElement.id = "iframePaddingElement";
            iframeEl.contentDocument.head.appendChild(iframePaddingElement);
        }
        console.log(iframeEl, iframePaddingElement);

        let bodyEl = iframeEl.contentDocument.body;
        let currBodyPadding = [Number.parseInt(bodyEl.style.paddingLeft),
            Number.parseInt(bodyEl.style.paddingRight)
        ];

        // If hypothesis expanded (this fn is only called if it was a real sidebar open/close)
        if (state.expanded) {
            main.classList.add('hypoIsOpen');

            // Inject reduced padding styling to epub iframe
            iframePaddingElement.textContent = epubjsStyleIfHypoOpen;

            // Calculate new size
            let rectViewer = viewer.getBoundingClientRect();
            let rectHypo = hypoSidebar.getBoundingClientRect();
            let spaceNeeded = Number.parseFloat(rectViewer.right - (rectHypo.left - rectHypo.width));
            let pct = spaceNeeded / Number.parseFloat(rectViewer.width);
            pct = (1 - pct) * 100;
            pct = Number.parseInt(pct).toString();
            pct = pct + '%';
            console.log('resizeDetails', {pct, spaceNeeded, rectHypo, rectViewer});
            rendition.resize(pct);

            let scrollNew = currScroll + 0.262 * currScroll;
            wait(300).then(() => scrollTo({ 'top': scrollNew }));

        } else if ((state.expanded === false)) {
            rendition.resize("100%");
            main.classList.remove("hypoIsOpen");
            iframePaddingElement.textContent = "";

            let scrollNew = currScroll / 1.262;
            wait(300)
                .then(() => scrollTo({ 'top': scrollNew }));

        }

    };

}