import { getBaseUrl } from '../../utils/config';
import { type ObjectPreview } from './types';

type SolrDoc = {
  id: string;
  'cug.matrikel.name.full': string;
};

type SolrResponse = {
  response: {
    numFound: number;
    docs: SolrDoc[];
  };
};

function mapDocToPreview(doc: SolrDoc): ObjectPreview {
  return {
    id: doc.id,
    title: doc['cug.matrikel.name.full'],
  };
}

export async function searchObjectPreviews(
  objectType: string,
  query: string,
  signal?: AbortSignal
): Promise<ObjectPreview[]> {
  const params = new URLSearchParams({
    q: `objectType:${objectType}`,
    fq: `cug.matrikel.name.plain:*${query}*`,
    fl: 'id,cug.matrikel.name.full',
    wt: 'json',
    rows: '10',
  });

  const response = await fetch(`${getBaseUrl()}api/v1/search?${params}`, {
    signal,
  });

  if (!response.ok) {
    throw new Error(
      `Solr search failed: ${response.status} ${response.statusText}`
    );
  }

  const data: SolrResponse = await response.json();
  return (data.response?.docs ?? []).map(mapDocToPreview);
}
