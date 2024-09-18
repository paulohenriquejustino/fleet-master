class ItemChecklist {
  String title;
  String description;
  ItemChecklistStatus? checked;
  String comment;

  ItemChecklist(this.title, this.description): checked = null, comment = '';
}

enum ItemChecklistStatus {
  conforme,
  naoConforme,
  inexistente,
}
