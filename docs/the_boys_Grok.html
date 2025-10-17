<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Boys Shows</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #1a1a1a;
            color: #f0f0f0;
            margin: 20px;
            font-size: 1.2rem;
        }
        h1 {
            font-size: 2rem;
            text-align: center;
            color: #ffffff;
        }
        h2 {
            font-size: 1.5rem;
            color: #4CAF50;
            cursor: pointer;
            margin: 10px 0;
        }
        h3.show-title {
            font-size: 1.5rem;
            color: #2196F3;
            margin-left: 20px;
            cursor: pointer;
            display: flex;
            flex-wrap: wrap;
            align-items: baseline;
        }
        h3.show-title span.overview {
            font-size: 0.9rem;
            color: #bbb;
            margin-left: 10px;
        }
        h3.show-title span.source {
            font-size: 0.8rem;
            color: #fff;
            margin-left: 10px;
            background-color: #444;
            padding: 2px 5px;
            border-radius: 3px;
        }
        h3.season-title {
            font-size: 1.3rem;
            color: #4CAF50;
            margin-left: 20px;
            cursor: pointer;
        }
        .toggle {
            display: inline-block;
            width: 30px;
            height: 30px;
            text-align: center;
            background-color: #333;
            color: #fff;
            border-radius: 5px;
            margin-right: 10px;
            line-height: 30px;
            font-size: 1.5rem;
            user-select: none;
        }
        .toggle:focus {
            outline: 3px solid #ffeb3b;
        }
        .hidden {
            display: none;
        }
        .section-header {
            background-color: #222;
            font-weight: bold;
            padding: 5px;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin: 5px 0;
            display: flex;
            flex-direction: column;
        }
        .data-table .header-row {
            display: flex;
            background-color: #333;
        }
        .data-table .data-row {
            display: flex;
            border-bottom: 1px solid #444;
        }
        .data-table .col {
            flex: 1;
            padding: 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            min-width: 80px; /* Prevent collapse */
        }
        .data-table .col.description {
            flex: 2; /* Wider for descriptions */
            white-space: normal;
            word-wrap: break-word;
            min-width: 150px;
        }
        .data-table .show-row { background-color: #333; }
        .data-table .season-row { background-color: #444; }
        .data-table .episode-row, .data-table .movie-row { background-color: #555; }
        .status-buttons {
            white-space: nowrap;
            display: flex;
            gap: 5px;
        }
        .status-btn {
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1rem;
            min-width: 80px;
            tabindex: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .status-btn:focus {
            outline: 3px solid #ffeb3b;
        }
        .status-btn.watching { background-color: #2196F3; color: white; }
        .status-btn.watched { background-color: #4CAF50; color: white; }
        .status-btn.unmark { background-color: #f44336; color: white; }
        .watching { background-color: rgba(33, 150, 243, 0.1); }
        .watched { background-color: rgba(76, 175, 80, 0.1); }
        .watch-link {
            display: inline-block;
            padding: 3px 6px;
            background-color: #333;
            color: #fff;
            text-decoration: none;
            border-radius: 3px;
            font-size: 0.9rem;
            margin: 1px;
            white-space: nowrap;
        }
        .watch-link:hover, .watch-link:focus {
            background-color: #555;
            outline: 2px solid #ffeb3b;
        }
        .app-button {
            padding: 5px 10px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 5px;
        }
        .filter-toggles {
            margin: 10px 0;
            display: flex;
            gap: 10px;
        }
        .filter-btn {
            padding: 5px 10px;
            background-color: #333;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .filter-btn.active {
            background-color: #4CAF50;
        }
        a, .toggle, h2, h3, .status-btn { outline: none; }
        a:focus, .toggle:focus, h2:focus, h3:focus, .status-btn:focus {
            outline: 3px solid #ffeb3b;
        }
    </style>
</head>
<body>
    <h1>The Boys Shows</h1>

    <!-- Filter Toggles -->
    <div class="filter-toggles">
        <button class="filter-btn" id="toggle-complete" onclick="toggleComplete()">Hide Complete</button>
        <button class="filter-btn" id="toggle-watched" onclick="toggleWatched()">Show Watched + Watching</button>
    </div>

    <!-- Shows Section -->
    <h2 id="shows-toggle" tabindex="0" onclick="toggleSection('shows')"><span class="toggle">+</span> Shows</h2>
    <div id="shows" class="hidden"></div>

    <!-- Movies Section -->
    <h2 id="movies-toggle" tabindex="0" onclick="toggleSection('movies')"><span class="toggle">+</span> Movies</h2>
    <div id="movies" class="hidden"></div>

    <script>
        // Base URLs
        const baseTmdbTv = 'https://www.themoviedb.org/tv/';
        const baseTmdbMovie = 'https://www.themoviedb.org/movie/';
        const baseVidSrcTv = 'https://vidsrc.net/embed/tv/';
        const baseVidSrcMovie = 'https://vidsrc.net/embed/movie/';
        const baseMappleTv = 'https://mapple.tv/watch/tv/';
        const baseMappleMovie = 'https://mapple.tv/watch/movie/';
        const baseNunFlixTv = 'https://nunflix.cc/watch/tv/';
        const baseNunFlixMovie = 'https://nunflix.cc/watch/movie/';

        // Hide/Show Toggle
        function toggleSection(id) {
            const section = document.getElementById(id);
            const toggle = section.previousElementSibling.querySelector('.toggle');
            if (section.classList.contains('hidden')) {
                section.classList.remove('hidden');
                toggle.textContent = '–';
                section.previousElementSibling.setAttribute('aria-expanded', 'true');
            } else {
                section.classList.add('hidden');
                toggle.textContent = '+';
                section.previousElementSibling.setAttribute('aria-expanded', 'false');
            }
        }

        // Status Toggle (Watching/Watched)
        function toggleStatus(entryId, action) {
            const row = document.getElementById(entryId);
            const currentState = row.dataset.status || 'none';
            let newState = currentState;
            const buttonsCell = row.querySelector('.status-buttons');

            if (action === 'watching' && currentState !== 'watching') {
                newState = 'watching';
            } else if (action === 'watched' && currentState !== 'watched') {
                newState = 'watched';
            } else {
                newState = 'none'; // Unmark
            }

            row.dataset.status = newState;
            row.classList.remove('watching', 'watched');
            if (newState !== 'none') {
                row.classList.add(newState);
            }

            // Update buttons with icons
            buttonsCell.innerHTML = '';
            if (newState === 'none') {
                buttonsCell.innerHTML += '<button class="status-btn" onclick="toggleStatus(\'' + entryId + '\', \'watching\')">⏳ Mark Watching</button>';
                buttonsCell.innerHTML += '<button class="status-btn" onclick="toggleStatus(\'' + entryId + '\', \'watched\')">✅ Mark Watched</button>';
            } else if (newState === 'watching') {
                buttonsCell.innerHTML += '<button class="status-btn unmark" onclick="toggleStatus(\'' + entryId + '\', \'none\')">❌ Unmark</button>';
                buttonsCell.innerHTML += '<button class="status-btn watched" onclick="toggleStatus(\'' + entryId + '\', \'watched\')">✅ Mark Watched</button>';
            } else if (newState === 'watched') {
                buttonsCell.innerHTML += '<button class="status-btn unmark" onclick="toggleStatus(\'' + entryId + '\', \'none\')">❌ Unmark</button>';
                buttonsCell.innerHTML += '<button class="status-btn watching" onclick="toggleStatus(\'' + entryId + '\', \'watching\')">⏳ Mark Watching</button>';
            }

            // Save to localStorage
            localStorage.setItem('status-' + entryId, newState);
        }

        // Open App Function (Web Fallback)
        function openApp(source, name) {
            let url;
            if (source === 'Netflix') {
                url = `netflix://search?q=${encodeURIComponent(name)}`; // Deep link attempt
                // Fallback to web
                if (!navigator.userAgent.match(/(iPad|iPhone|Android)/)) {
                    url = `https://www.netflix.com/search?q=${encodeURIComponent(name)}`;
                }
            } else if (source === 'Prime Video') {
                url = `amazonvideo://store/search?query=${encodeURIComponent(name)}`; // Deep link attempt
                // Fallback to web
                if (!navigator.userAgent.match/(iPad|iPhone|Android)/) {
                    url = `https://www.amazon.com/gp/search?index=video&keywords=${encodeURIComponent(name)}`;
                }
            }
            if (url) {
                window.open(url, '_blank');
            }
        }

        // Filter Toggles
        let hideComplete = true; // Default hide complete/dont show
        let showWatchedWatching = true; // Default show watched + watching (false for watching only)

        function toggleComplete() {
            hideComplete = !hideComplete;
            document.getElementById('toggle-complete').textContent = hideComplete ? 'Show Complete' : 'Hide Complete';
            applyFilters();
        }

        function toggleWatched() {
            showWatchedWatching = !showWatchedWatching;
            document.getElementById('toggle-watched').textContent = showWatchedWatching ? 'Show Watching Only' : 'Show Watched + Watching';
            applyFilters();
        }

        function applyFilters() {
            document.querySelectorAll('.season-section, .episode-row, .movie-row').forEach(item => {
                const status = item.dataset.status || 'none';
                let shouldHide = false;

                if (hideComplete && status === 'watched') {
                    shouldHide = true;
                }

                if (!showWatchedWatching && status !== 'watching') {
                    shouldHide = true;
                }

                item.style.display = shouldHide ? 'none' : 'flex';
            });
        }

        // Load and Parse Data from File
        function loadData() {
            fetch('show_and_movie_data.tile.txt')
                .then(response => response.text())
                .then(data => {
                    const lines = data.split('\n');
                    let currentSection = null;
                    let currentShow = null;
                    let currentSeason = null;

                    const showsContainer = document.getElementById('shows');
                    const moviesContainer = document.getElementById('movies');

                    showsContainer.innerHTML = '<div class="section-header">Name | Date | Status | Source | Schedule</div><div class="data-table"></div>';
                    moviesContainer.innerHTML = '<div class="section-header">Name | Release Date | Runtime | Overview | Streaming Source | VidSrc 📺 | Mapple 🌐 | NunFlix 🎬 | TBD ❓</div><div class="data-table"></div>';
                    const showsTable = showsContainer.querySelector('.data-table');
                    const moviesTable = moviesContainer.querySelector('.data-table');

                    lines.forEach(line => {
                        line = line.trim();
                        if (!line || line.startsWith('#')) return;

                        if (line.startsWith('SHOWS') || line.startsWith('MOVIES')) {
                            currentSection = line;
                            return;
                        }

                        const [type, ...rest] = line.split('|').map(field => field.trim().replace(/\n/g, ' ')); // Trim and replace newlines

                        if (type === 'show') {
                            currentShow = rest;
                            const [tmdbId, name, overview, numSeasons, date, status, source, schedule] = currentShow;
                            const safeId = tmdbId + '-' + name.replace(/[^a-zA-Z0-9]/g, '-').replace(/-+/g, '-');
                            const showDiv = document.createElement('div');
                            showDiv.className = 'show-section';
                            const tmdbLink = baseTmdbTv + tmdbId;
                            showDiv.innerHTML = `<h3 class="show-title" id="show-${safeId}-toggle" tabindex="0"><span class="toggle">+</span> ${name} <span class="overview">${overview}</span> <span class="source">${source}</span></h3><div id="show-${safeId}" class="hidden"><div class="data-table"><div class="header-row"><div class="col">Name</div><div class="col">Date</div><div class="col">Status</div><div class="col">Source</div><div class="col">Schedule</div><div class="col">TMDB Link</div></div><div class="data-row show-row"><div class="col">${name}</div><div class="col">${date}</div><div class="col">${status}</div><div class="col">${source}${source === 'Netflix' || source === 'Prime Video' ? `<button class="app-button" onclick="openApp('${source}', '${name.replace(/'/g, "\\'")}')">Open in App</button>` : ''}</div><div class="col">${schedule}</div><div class="col"><a href="${tmdbLink}" class="watch-link" target="_blank">TMDB</a></div></div></div></div>`;
                            showsTable.appendChild(showDiv);
                            document.getElementById(`show-${safeId}-toggle`).addEventListener('click', () => toggleSection(`show-${safeId}`));
                        } else if (type === 'season' && currentShow) {
                            currentSeason = rest;
                            const [tmdbId, seasonNum, year, overview, watchStatus] = currentSeason;
                            const safeShowId = currentShow[1].replace(/[^a-zA-Z0-9]/g, '-').replace(/-+/g, '-');
                            const seasonDiv = document.createElement('div');
                            seasonDiv.className = 'season-section';
                            seasonDiv.dataset.status = watchStatus;
                            seasonDiv.innerHTML = `<h3 class="season-title" id="show-${safeShowId}-season-${seasonNum}-toggle" tabindex="0"><span class="toggle">+</span> Season ${seasonNum} (${year}) • ${overview}</h3><div id="show-${safeShowId}-season-${seasonNum}" class="hidden"><div class="data-table"><div class="header-row"><div class="col">Episode</div><div class="col">Name</div><div class="col">Date</div><div class="col description">Description</div><div class="col">Runtime</div><div class="col">Streaming Source</div><div class="col">VidSrc 📺</div><div class="col">Mapple 🌐</div><div class="col">NunFlix 🎬</div><div class="col">TBD ❓</div></div></div></div>`;
                            document.getElementById(`show-${safeShowId}`).querySelector('.data-table').appendChild(seasonDiv);
                            document.getElementById(`show-${safeShowId}-season-${seasonNum}-toggle`).addEventListener('click', () => toggleSection(`show-${safeShowId}-season-${seasonNum}`));
                        } else if (type === 'episode' && currentSeason) {
                            const [tmdbId, epNum, name, date, desc, runtime, source, vidSrc, mapple, nunFlix, tbd, watchStatus] = rest;
                            const safeShowId = currentShow[1].replace(/[^a-zA-Z0-9]/g, '-').replace(/-+/g, '-');
                            const epDiv = document.createElement('div');
                            epDiv.className = `episode-row data-row ${watchStatus}`;
                            epDiv.id = `episode-${safeShowId}-s${currentSeason[1]}-e${epNum}`;
                            const generatedVidSrc = vidSrc === 'N/A' ? baseVidSrcTv + tmdbId + '/' + currentSeason[1] + '/' + epNum : vidSrc;
                            const generatedMapple = mapple === 'N/A' ? baseMappleTv + tmdbId + '/' + currentSeason[1] + '/' + epNum : mapple;
                            const generatedNunFlix = nunFlix === 'N/A' ? baseNunFlixTv + tmdbId + '/' + currentSeason[1] + '/' + epNum : nunFlix;
                            const generatedTbd = tbd === 'N/A' ? 'N/A' : tbd;
                            epDiv.innerHTML = `<div class="col">${epNum}</div><div class="col">${name}</div><div class="col">${date}</div><div class="col description">${desc}</div><div class="col">${runtime}</div><div class="col">${source}</div><div class="col"><a href="${generatedVidSrc}" class="watch-link" target="_blank">📺</a></div><div class="col"><a href="${generatedMapple}" class="watch-link" target="_blank">🌐</a></div><div class="col"><a href="${generatedNunFlix}" class="watch-link" target="_blank">🎬</a></div><div class="col"><a href="${generatedTbd}" class="watch-link" target="_blank">❓</a></div><div class="status-buttons"><button class="status-btn" onclick="toggleStatus('episode-${safeShowId}-s${currentSeason[1]}-e${epNum}', 'watching')">⏳ Mark Watching</button><button class="status-btn" onclick="toggleStatus('episode-${safeShowId}-s${currentSeason[1]}-e${epNum}', 'watched')">✅ Mark Watched</button></div>`;
                            document.getElementById(`show-${safeShowId}-season-${seasonNum}`).querySelector('.data-table').appendChild(epDiv);
                        } else if (type === 'movie') {
                            const [tmdbId, name, overview, releaseDate, rating, runtime, source, vidSrc, mapple, nunFlix, tbd, watchStatus] = rest;
                            const safeId = tmdbId + '-' + name.replace(/[^a-zA-Z0-9]/g, '-').replace(/-+/g, '-');
                            const movieDiv = document.createElement('div');
                            movieDiv.className = 'movie-section';
                            const tmdbLink = baseTmdbMovie + tmdbId;
                            const generatedVidSrc = vidSrc === 'N/A' ? baseVidSrcMovie + '/' + tmdbId : vidSrc;
                            const generatedMapple = mapple === 'N/A' ? baseMappleMovie + tmdbId : mapple;
                            const generatedNunFlix = nunFlix === 'N/A' ? baseNunFlixMovie + tmdbId : nunFlix;
                            const generatedTbd = tbd === 'N/A' ? 'N/A' : tbd;
                            movieDiv.innerHTML = `<div class="data-table"><div class="header-row"><div class="col">Name</div><div class="col">Release Date</div><div class="col">Runtime</div><div class="col description">Overview</div><div class="col">Streaming Source</div><div class="col">VidSrc 📺</div><div class="col">Mapple 🌐</div><div class="col">NunFlix 🎬</div><div class="col">TBD ❓</div></div><div id="movie-${safeId}" class="movie-row data-row ${watchStatus}"><div class="col">${name}</div><div class="col">${releaseDate}</div><div class="col">${runtime}</div><div class="col description">${overview}</div><div class="col">${source}${source === 'Netflix' || source === 'Prime Video' ? `<button class="app-button" onclick="openApp('${source}', '${name.replace(/'/g, "\\'")}')">Open in App</button>` : ''}</div><div class="col"><a href="${generatedVidSrc}" class="watch-link" target="_blank">📺</a></div><div class="col"><a href="${generatedMapple}" class="watch-link" target="_blank">🌐</a></div><div class="col"><a href="${generatedNunFlix}" class="watch-link" target="_blank">🎬</a></div><div class="col"><a href="${generatedTbd}" class="watch-link" target="_blank">❓</a></div><div class="status-buttons"><button class="status-btn" onclick="toggleStatus('movie-${safeId}', 'watching')">⏳ Mark Watching</button><button class="status-btn" onclick="toggleStatus('movie-${safeId}', 'watched')">✅ Mark Watched</button></div></div></div>`;
                            document.getElementById('movies').querySelector('.data-table').appendChild(movieDiv);
                        }
                    });

                    // Apply filters after loading
                    applyFilters();

                    // Apply saved statuses
                    document.querySelectorAll('[id^="episode-"], [id^="movie-"]').forEach(row => {
                        const savedState = localStorage.getItem('status-' + row.id);
                        if (savedState) {
                            toggleStatus(row.id, savedState === 'none' ? 'none' : savedState);
                        }
                    });
                })
                .catch(error => {
                    console.error('Error loading data:', error);
                    document.getElementById('shows').innerHTML = '<p>Error loading shows data: ' + error.message + '. Ensure show_and_movie_data.tile.txt is in the same directory and correctly formatted.</p>';
                    document.getElementById('movies').innerHTML = '<p>Error loading movies data: ' + error.message + '. Ensure show_and_movie_data.tile.txt is in the same directory and correctly formatted.</p>';
                });
        }

        // Initialize on DOM ready
        document.addEventListener('DOMContentLoaded', loadData);
    </script>
</body>
</html>
