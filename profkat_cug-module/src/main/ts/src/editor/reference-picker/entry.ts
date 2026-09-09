import { Autocomplete } from '../../autocomplete';
import { type ObjectPreview } from './types';
import { searchObjectPreviews } from './client';

function getDisplayText(preview: ObjectPreview) {
  if (preview.id && preview.title) {
    return `${preview.title} (${preview.id})`;
  }
  return preview.id;
}

async function setupReferencePicker(container: HTMLElement): Promise<void> {
  const input = container.querySelector<HTMLInputElement>('[data-input]');
  const href = container.querySelector<HTMLInputElement>('[data-href]');
  const title = container.querySelector<HTMLInputElement>('[data-title]');

  if (!input || !href || !title) {
    console.error('reference-picker: text, href and title input are required');
    return;
  }

  const objectType = container.dataset.objectType;
  if (!objectType) return;

  const textInput = input!;
  const hrefInput = href!;
  const titleInput = title!;

  const badge = container.querySelector<HTMLElement>('[data-badge]');

  function clearReference() {
    hrefInput.value = '';
    textInput.value = '';
    titleInput.value = '';
    container.classList.remove('is-locked');
    textInput.readOnly = false;
    textInput.focus();
    textInput.select();
  }

  function setReference(preview: ObjectPreview) {
    textInput.value = getDisplayText(preview);
    titleInput.value = preview.title;
    hrefInput.value = preview.id;
    container.classList.add('is-locked');
    textInput.readOnly = true;
  }

  if (hrefInput.value) {
    const preview = hrefInput.value;
    if (preview) {
      setReference({ id: preview, title: titleInput.value });
    }
  }

  new Autocomplete<ObjectPreview>(textInput, {
    fetchData: query => searchObjectPreviews(objectType, query),
    getDisplayText: item => getDisplayText(item),
    onItemSelected: setReference,
    debounceMs: 0,
  });

  badge?.addEventListener('click', clearReference);

  document.addEventListener('click', e => {
    const target = e.target as HTMLElement;
    if (!container.contains(target) && !hrefInput.value) {
      textInput.value = '';
    }
  });
}

function initReferencePickers(): void {
  document
    .querySelectorAll('.cug-reference-picker')
    .forEach(el => setupReferencePicker(el as HTMLElement));
}

document.addEventListener('DOMContentLoaded', initReferencePickers);
