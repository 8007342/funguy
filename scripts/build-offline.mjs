import { readdir, readFile, writeFile } from 'node:fs/promises';
import { createHash } from 'node:crypto';
const root = new URL('../build/web/', import.meta.url);
async function walk(dir = '') {
  const entries = await readdir(new URL(dir, root), { withFileTypes: true });
  return (await Promise.all(entries.map(e => e.isDirectory() ? walk(`${dir}${e.name}/`) : `${dir}${e.name}`))).flat();
}
// Only built, same-origin resources are installed; no CDN is needed in the field.
const paths = (await walk()).filter(p => !['sw.js', 'flutter_service_worker.js', '_headers', '.last_build_id'].includes(p) && !p.endsWith('.symbols')).sort();
const hash = createHash('sha256');
for (const path of paths) hash.update(await readFile(new URL(path, root)));
const version = hash.digest('hex').slice(0, 16);
const source = await readFile(new URL('../web/sw.js', import.meta.url), 'utf8');
await writeFile(new URL('sw.js', root), source.replace('__VERSION__', version).replace('__ASSETS__', JSON.stringify(paths.map(p => `./${p}`))));
console.log(`Offline shell ${version}: ${paths.length} files. Field collections require a separate verified pack.`);
