export type Label = {
  lang: string;
  text: string;
};

export type Category = {
  ID: string;
  labels: Label[];
};

export type Classification = {
  ID: string;
  labels: Label[];
  categories: Category[];
};
