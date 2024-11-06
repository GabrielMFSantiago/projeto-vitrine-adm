class Item {
  String nomeitem;
  String cor;
  String tamanho;
  String descricao;
  String preco;
  String img;
  String? userItem;
  String cidade;  

  Item(
    this.nomeitem,
    this.cor,
    this.tamanho,
    this.descricao,
    this.preco,
    this.img,
    this.userItem,
    {required this.cidade, required String timestamp}  
  );
}
