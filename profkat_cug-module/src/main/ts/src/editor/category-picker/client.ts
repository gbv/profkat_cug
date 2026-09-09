import { getBaseUrl } from '../../utils/config';
import { type Category, type Classification } from './types';

const classificationCache = new Map<string, Promise<Classification>>();

function fetchClassification(
  classificationId: string
): Promise<Classification> {
  const url = new URL(
    `api/v2/classifications/${classificationId}.json`,
    getBaseUrl()
  );
  return fetch(url).then(res => {
    if (!res.ok) throw new Error(`Fetch failed: ${res.status}`);
    return res.json();
  });
}

function getClassification(classificationId: string): Promise<Classification> {
  let cached = classificationCache.get(classificationId);
  if (!cached) {
    cached = fetchClassification(classificationId);
    classificationCache.set(classificationId, cached);
  }
  return cached;
}

export async function getCategory(
  classificationId: string,
  categoryId: string
): Promise<Category | undefined> {
  const classification = await getClassification(classificationId);

  return classification.categories.find(cat => cat.ID === categoryId);
}

export async function searchCategories(
  classificationId: string,
  query: string
): Promise<Category[]> {
  const classification = await getClassification(classificationId);
  const lowerQuery = query.toLowerCase();

  return classification.categories.filter(cat =>
    cat.labels.some(label => label.text.toLowerCase().includes(lowerQuery))
  );
}
