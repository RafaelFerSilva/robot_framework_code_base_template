class CollectionsHelper:
    """Library for complex collection operations in Robot Framework."""

    def removes_objects_with_the_same_key_and_returns_a_list_with_unique_objects_and_their_quantity(self, lista_objetos, key='Nome'):
        """
        Consolidates objects by key, keeping only one of each and adding the count.

        Arguments:
        - lista_objetos: List of dictionaries to process
        - key: Key to group by (default: 'Nome')

        Returns:
        - List of unique dictionaries with occurrence count added in the 'Quantidade' key
        """
        count_keys = {}
        object_by_key = {}

        for objeto in lista_objetos:
            value_key = objeto.get(key)
            if value_key is None:
                continue

            if value_key in count_keys:
                count_keys[value_key] += 1
            else:
                count_keys[value_key] = 1
                object_by_key[value_key] = objeto

        resultado = []
        for value_key, count in count_keys.items():
            objeto_com_contagem = object_by_key[value_key].copy()
            objeto_com_contagem['Quantidade'] = count
            resultado.append(objeto_com_contagem)

        # Assuming robot framework's dicts/lists can be printed/logged
        # but in Python we don't automatically Log Many. The caller can log it.
        return resultado
