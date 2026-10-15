import cityCatalog from "./data/iran-cities.json";
const catalog: Readonly<Record<string, readonly string[]>> = cityCatalog;
/** Static local catalog: selecting a province needs no API or network request. */
export function citiesForProvince(province: string): readonly string[] {
  return Object.prototype.hasOwnProperty.call(catalog, province) ? catalog[province] : [];
}
