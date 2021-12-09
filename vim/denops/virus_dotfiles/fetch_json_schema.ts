import xdg from 'https://deno.land/x/xdg@v9.4.0/src/mod.deno.ts';
import * as path from "https://deno.land/std/path/mod.ts";

/**
  * get json schema object
  *
  * @param cacheRoot:
  *     dir name for save file.
  *     the file was saved cacheRoot/virus_dotfiles/catalog.*
  *
  * TODO: see Age header
  * TODO: report fetch or cached
  */
export async function getJsonSchema (cacheRoot: string): Promise<string> {
  const jsonSchemaStoreCatalogAPI = "https://www.schemastore.org/api/json/catalog.json";
  const refetchInterval = 86400*1000;

  const cacheDir = path.join(cacheRoot, "virus_dotfiles");
  await Deno.mkdir(cacheDir, {
    recursive: true
  });
  const cacheSchema = path.join(cacheDir, "catalog.json");
  const cacheSchemaEtagFile = path.join(cacheDir, "catalog.etag");

  const cacheEtagStat = await Deno.stat(cacheSchemaEtagFile).catch(e => {
    if (e instanceof Deno.errors.NotFound) {
      return;
    }
    throw e;
  });
  const eTagModified = cacheEtagStat?.mtime?.getTime() ?? 0
  const currentSchema = await Deno.readTextFile(cacheSchema).catch(e => {
    if (e instanceof Deno.errors.NotFound) {
      return;
    }
    throw e;
  });
  const useLocalCache = currentSchema && Date.now() < (eTagModified + refetchInterval)
  if (useLocalCache) {
    console.log('useLocalCache');
    return currentSchema;
  }

  const currentEtag = await Deno.readTextFile(cacheSchemaEtagFile).catch(e => {
    if (e instanceof Deno.errors.NotFound) {
      return;
    }
    throw e;
  });

  return await fetch(jsonSchemaStoreCatalogAPI, {
    headers: {
      "If-None-Match": currentEtag ?? ""
    }
  }).then(async (resp) => {
    if (resp.ok) {
      const etag = resp.headers.get('ETag');
      if (etag) {
        await Deno.writeTextFile(cacheSchemaEtagFile, etag);
      }
      const catalogData = await resp.text();
      await Deno.writeTextFile(cacheSchema, catalogData);
      return catalogData;
    }
    if (resp.status === 304) {
      const etag = resp.headers.get('ETag');
      if (etag) {
        await Deno.writeTextFile(cacheSchemaEtagFile, etag);
      }
      return currentSchema;
    }
    console.error("Unexpected response", resp);
    throw new Error("Unexpected reponse")
  })
}
if (import.meta.main) {
  getJsonSchema(xdg.cache())
}
