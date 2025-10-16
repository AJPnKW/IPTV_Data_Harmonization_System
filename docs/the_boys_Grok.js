<script>
/* === the_boys_Grok.js v1.0 (2025-10-16) ===
   Purpose: fix SyntaxError + missing global handlers; robust load/render/status.
   Author: AJP + ChatGPT
*/

/* ---------- CONFIG ---------- */
const DATA_URL = 'show_and_movie_data.tile.txt'; // same folder as HTML
const NS = 'ajp.watchstatus';                    // localStorage namespace

/* Base link builders (adjust if you prefer) */
const links = {
  tmdbShow: (id) => `https://www.themoviedb.org/tv/${id}`,
  tmdbMovie: (id) => `https://www.themoviedb.org/movie/${id}`,
  vidsrcTv: (id, s, e) => `https://vidsrc.net/embed/tv/${id}/${s}/${e}`,
  vidsrcMovie: (id) => `https://vidsrc.net/embed/movie/${id}`,
  nunflix: (query) => `https://nunflix.com/search?q=${encodeURIComponent(query)}`,
  mapple: (query) => `https://www.mapleflix.com/search?q=${encodeURIComponent(query)}` // rename if your target differs
};

/* ---------- UTIL ---------- */
const qs  = (s, r = document) => r.querySelector(s);
const qsa = (s, r = document) => [...r.querySelectorAll(s)];

function keyFor(type, tmdbId, seasonNum = null, epNum = null) {
  // e.g., ajp.watchstatus.show.12345.S1.E2  |  ajp.watchstatus.movie.6789
  let k = `${NS}.${type}.${tmdbId}`;
  if (seasonNum != null) k += `.S${seasonNum}`;
  if (epNum    != null) k += `.E${epNum}`;
  return k;
}

function getStatus(type, tmdbId, seasonNum = null, epNum = null) {
  return localStorage.getItem(keyFor(type, tmdbId, seasonNum, epNum)) || 'none';
}
function setStatus(type, tmdbId, seasonNum, epNum, status) {
  localStorage.setItem(keyFor(type, tmdbId, seasonNum, epNum), status);
}

/* ---------- PARSER ---------- */
/* Pipe-delimited with possible quoted fields. Lines starting with '#' are comments.
   Types: show|..., season|..., episode|..., movie|... */
function parseDataFile(text) {
  const lines = text.split(/\r?\n/).map(l => l.trim()).filter(Boolean);
  const shows = new Map(); // tmdbId -> {meta, seasons: Map(seasonNum -> {... episodes: []})}
  const movies = [];

  for (const raw of lines) {
    if (raw.startsWith('#')) continue;

    const fields = splitPipes(raw);
    const kind = (fields[0] || '').toLowerCase();

    if (kind === 'show') {
      // show|tmdb_id|name|overview|#_of_seasons|date|status|source|schedule|tmdb_url_link
      const [, id, name, overview, nSeasons, date, status, source, schedule, tmdbUrl] = fields;
      shows.set(id, {
        id, name, overview, nSeasons: toInt(nSeasons), date, status, source, schedule, tmdbUrl,
        seasons: new Map()
      });
    } else if (kind === 'season') {
      // season|tmdb_id|seasonNum|year|overview|watchStatus
      const [, showId, seasonNum, year, overview, watchStatus] = fields;
      const show = shows.get(showId);
      if (!show) continue;
      show.seasons.set(seasonNum, { showId, seasonNum, year, overview, watchStatus, episodes: [] });
    } else if (kind === 'episode') {
      // episode|tmdb_id|epNum|name|date|desc|runtime|source|vidSrc|mapple|nunFlix|tbd|watchStatus
      const [, showId, epNum, name, date, desc, runtime, source, vidSrc, mapple, nunFlix, tbd, watchStatus] = fields;
      const show = shows.get(showId);
      if (!show) continue;
      // Put into the *latest* season if not provided explicitly in data file; else you can extend the format to include seasonNum.
      // Prefer explicit season mapping: if you have "seasonNum", add it in data and change here accordingly.
      const latest = pickLatestSeason(show);
      if (!latest) continue;
      latest.episodes.push({ showId, epNum, name, date, desc, runtime, source, vidSrc, mapple, nunFlix, tbd, watchStatus });
    } else if (kind === 'movie') {
      // movie|tmdb_id|name|overview|releaseDate|rating|runtime|source|vidSrc|mapple|nunFlix|tbd|watchStatus
      const [, id, name, overview, releaseDate, rating, runtime, source, vidSrc, mapple, nunFlix, tbd, watchStatus] = fields;
      movies.push({ id, name, overview, releaseDate, rating, runtime, source, vidSrc, mapple, nunFlix, tbd, watchStatus });
    }
  }

  return { shows, movies };
}

function splitPipes(line) {
  // Robust CSV-like splitter for pipes with optional "quoted|fields"
  const out = [];
  let cur = '', inQ = false;
  for (let i = 0; i < line.length; i++) {
    const ch = line[i];
    if (ch === '"') {
      inQ = !inQ;
      continue;
    }
    if (ch === '|' && !inQ) {
      out.push(cur);
      cur = '';
    } else {
      cur += ch;
    }
  }
  out.push(cur);
  return out.map(s => s.replace(/\\n/g, '\n').trim());
}
const toInt = (x) => (x == null || x === '' ? null : parseInt(x, 10));

function pickLatestSeason(show) {
  // Choose max numeric seasonNum
  const nums = [...show.seasons.keys()].map(n => parseInt(n, 10)).filter(n => !Number.isNaN(n));
  if (!nums.length) return null;
  const max = Math.max(...nums);
  return show.seasons.get(String(max));
}

/* ---------- RENDER ---------- */
function renderAll({ shows, movies }) {
  const showsRoot = qs('#shows-root');
  const moviesRoot = qs('#movies-root');
  showsRoot.innerHTML = '';
  moviesRoot.innerHTML = '';

  // SHOWS
  for (const show of shows.values()) {
    const showEl = renderShow(show);
    showsRoot.appendChild(showEl);
  }

  // MOVIES
  for (const m of movies) {
    const movieEl = renderMovie(m);
    moviesRoot.appendChild(movieEl);
  }
}

function renderShow(show) {
  const wrap = document.createElement('section');
  wrap.className = 'show';
  wrap.dataset.tmdbId = show.id;

  wrap.innerHTML = `
    <header class="row show-row">
      <button class="toggle" aria-expanded="true" data-target="body">–</button>
      <h2 class="title">${esc(show.name)}</h2>
      <a class="link" href="${show.tmdbUrl || links.tmdbShow(show.id)}" target="_blank" rel="noopener">TMDB</a>
    </header>
    <div class="body">
      <p class="overview">${esc(show.overview || '')}</p>
      <div class="seasons"></div>
    </div>
  `;

  const seasonsRoot = qs('.seasons', wrap);
  const seasonsSorted = [...show.seasons.values()].sort((a,b) => parseInt(a.seasonNum,10) - parseInt(b.seasonNum,10));
  for (const s of seasonsSorted) {
    seasonsRoot.appendChild(renderSeason(show, s));
  }
  return wrap;
}

function renderSeason(show, season) {
  const el = document.createElement('article');
  el.className = 'season';
  el.dataset.season = season.seasonNum;

  el.innerHTML = `
    <header class="row season-row">
      <button class="toggle" aria-expanded="true" data-target="body">–</button>
      <h3 class="title">Season ${esc(season.seasonNum)} (${esc(season.year || '')})</h3>
    </header>
    <div class="body">
      <p class="overview">${esc(season.overview || '')}</p>
      <div class="episodes"></div>
    </div>
  `;

  const epsRoot = qs('.episodes', el);
  const epsSorted = [...season.episodes].sort((a,b) => parseInt(a.epNum,10) - parseInt(b.epNum,10));
  for (const e of epsSorted) {
    epsRoot.appendChild(renderEpisode(show.id, season.seasonNum, e));
  }
  return el;
}

function renderEpisode(showId, seasonNum, ep) {
  const status = getStatus('episode', showId, seasonNum, ep.epNum);
  const line = document.createElement('div');
  line.className = 'row episode-row';
  line.dataset.season = seasonNum;
  line.dataset.ep = ep.epNum;
  line.dataset.tmdbId = showId;

  const vidsrc = ep.vidSrc || links.vidsrcTv(showId, seasonNum, ep.epNum);
  const mapple = ep.mapple || links.mapple(`${ep.name} ${seasonNum}x${ep.epNum}`);
  const nun    = ep.nunFlix || links.nunflix(`${ep.name} ${seasonNum}x${ep.epNum}`);

  line.innerHTML = `
    <span class="cell num">E${esc(ep.epNum)}</span>
    <span class="cell name">${esc(ep.name || '')}</span>
    <span class="cell date">${esc(ep.date || '')}</span>
    <span class="cell actions">
      <button class="watching" title="Mark watching" data-action="watching">⏳</button>
      <button class="watched"  title="Mark watched"  data-action="watched">✅</button>
      <button class="unmark"   title="Unmark"        data-action="none">❌</button>
      <a class="app" href="${vidsrc}" target="_blank" rel="noopener" title="VidSrc">📺</a>
      <a class="app" href="${mapple}" target="_blank" rel="noopener" title="Mapple">🌐</a>
      <a class="app" href="${nun}"    target="_blank" rel="noopener" title="NunFlix">🎬</a>
    </span>
  `;

  updateRowStatusClass(line, status);
  return line;
}

function renderMovie(m) {
  const status = getStatus('movie', m.id, null, null);
  const line = document.createElement('div');
  line.className = 'row movie-row';
  line.dataset.tmdbId = m.id;

  const vidsrc = m.vidSrc || links.vidsrcMovie(m.id);
  const mapple = m.mapple || links.mapple(m.name);
  const nun    = m.nunFlix || links.nunflix(m.name);

  line.innerHTML = `
    <span class="cell name">${esc(m.name)}</span>
    <span class="cell date">${esc(m.releaseDate || '')}</span>
    <span class="cell actions">
      <button class="watching" title="Mark watching" data-action="watching">⏳</button>
      <button class="watched"  title="Mark watched"  data-action="watched">✅</button>
      <button class="unmark"   title="Unmark"        data-action="none">❌</button>
      <a class="app" href="${vidsrc}" target="_blank" rel="noopener" title="VidSrc">📺</a>
      <a class="app" href="${mapple}" target="_blank" rel="noopener" title="Mapple">🌐</a>
      <a class="app" href="${nun}"    target="_blank" rel="noopener" title="NunFlix">🎬</a>
    </span>
  `;

  updateRowStatusClass(line, status);
  return line;
}

function updateRowStatusClass(rowEl, status) {
  rowEl.classList.remove('status-watching', 'status-watched', 'status-none');
  rowEl.classList.add(`status-${status}`);
}

/* ---------- GLOBAL TOGGLES (for inline onclick) ---------- */
// These are exposed to window so your existing HTML onclick="..." keeps working.
function toggle(targetEl) {
  const btn = targetEl.closest('header')?.querySelector('.toggle');
  const body = targetEl.closest('section, article')?.querySelector('.body');
  if (!btn || !body) return;
  const expanded = btn.getAttribute('aria-expanded') === 'true';
  btn.setAttribute('aria-expanded', String(!expanded));
  btn.textContent = expanded ? '+' : '–';
  body.style.display = expanded ? 'none' : '';
}

// Called from inline onclick on section/show/season headers
window.toggleSection = function (el) {
  toggle(el);
};

// Filter: hide/show completed items (watched)
window.toggleComplete = function () {
  const hide = qs('#hide-complete')?.checked;
  document.body.classList.toggle('hide-complete', !!hide);
};

// Filter: show only watching vs watching+watched
window.toggleWatched = function () {
  const watchingOnly = qs('#watching-only')?.checked;
  document.body.classList.toggle('watching-only', !!watchingOnly);
};

/* ---------- INIT + DELEGATED EVENTS ---------- */
function init() {
  // Delegated clicks for status buttons
  document.addEventListener('click', (e) => {
    const btn = e.target.closest('button[data-action]');
    if (!btn) return;
    const row = e.target.closest('.episode-row, .movie-row');
    if (!row) return;

    const action = btn.dataset.action; // watching|watched|none
    if (row.classList.contains('episode-row')) {
      const tmdbId = row.dataset.tmdbId;
      const s = parseInt(row.dataset.season, 10);
      const ep = parseInt(row.dataset.ep, 10);
      setStatus('episode', tmdbId, s, ep, action);
      updateRowStatusClass(row, action);
    } else {
      const tmdbId = row.dataset.tmdbId;
      setStatus('movie', tmdbId, null, null, action);
      updateRowStatusClass(row, action);
    }
    // Apply filters immediately
    applyFilters();
  });

  // Data load
  fetch(DATA_URL, { cache: 'no-store' })
    .then(r => {
      if (!r.ok) throw new Error(`Failed to load data: ${r.status}`);
      return r.text();
    })
    .then(text => {
      const model = parseDataFile(text);
      renderAll(model);
      applyFilters();
    })
    .catch(err => {
      console.error(err);
      const t = qs('#error');
      if (t) t.textContent = String(err);
    });
}

function applyFilters() {
  const hideComplete = qs('#hide-complete')?.checked;
  const watchingOnly = qs('#watching-only')?.checked;

  for (const row of qsa('.episode-row, .movie-row')) {
    const isWatched  = row.classList.contains('status-watched');
    const isWatching = row.classList.contains('status-watching');

    let visible = true;
    if (hideComplete && isWatched) visible = false;
    if (watchingOnly && !isWatching) visible = false;

    row.style.display = visible ? '' : 'none';
  }
}

/* ---------- HELPERS ---------- */
function esc(s) {
  return String(s ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

document.addEventListener('DOMContentLoaded', init);
</script>
