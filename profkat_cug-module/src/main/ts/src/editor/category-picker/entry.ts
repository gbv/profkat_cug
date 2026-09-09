import { Autocomplete } from '../../autocomplete';
import { getCategory, searchCategories } from './client';
import { type Category, type Label } from './types';
import { getCurrentLang } from '../../utils/config';

function pickLabel(labels: Label[]): string {
  const lang = getCurrentLang();
  const match = labels.find(l => l.lang === lang);
  return match?.text ?? labels[0]?.text ?? '';
}

async function setupCategoryPicker(container: HTMLElement): Promise<void> {
  const input = container.querySelector<HTMLInputElement>('[data-input]');
  const hiddenInput = container.querySelector<HTMLInputElement>('[data-id]');

  if (!input || !hiddenInput) {
    console.error('category-picker: text and hidden input are required');
    return;
  }

  const classificationId = container.dataset.classificationId;
  if (!classificationId) return;

  const textInput = input!;
  const idInput = hiddenInput!;

  const badge = container.querySelector<HTMLElement>('[data-badge]');

  function clearCategory() {
    idInput.value = '';
    textInput.value = '';
    container.classList.remove('is-locked');
    textInput.readOnly = false;
    textInput.focus();
    textInput.select();
  }

  function setCategory(category: Category) {
    textInput.value = pickLabel(category.labels);
    idInput.value = category.ID;
    container.classList.add('is-locked');
    textInput.readOnly = true;
  }

  if (idInput.value) {
    const category = await getCategory(classificationId, idInput.value);
    if (category) {
      setCategory(category);
    } else {
      console.error(
        'Category "' +
          classificationId +
          ':' +
          hiddenInput.value +
          '" does not exist'
      );
    }
  }

  new Autocomplete<Category>(textInput, {
    fetchData: query => searchCategories(classificationId, query),
    getDisplayText: item => pickLabel(item.labels),
    onItemSelected: setCategory,
    debounceMs: 0,
  });

  badge?.addEventListener('click', clearCategory);

  document.addEventListener('click', e => {
    const target = e.target as HTMLElement;
    if (!container.contains(target) && !idInput.value) {
      textInput.value = '';
    }
  });
}

function initCategoryPickers(): void {
  document
    .querySelectorAll('.cug-category-picker')
    .forEach(el => setupCategoryPicker(el as HTMLElement));
}

document.addEventListener('DOMContentLoaded', initCategoryPickers);
