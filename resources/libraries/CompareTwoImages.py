from PIL import Image, ImageChops
import numpy as np
import requests
from io import BytesIO
from skimage.metrics import structural_similarity as ssim
from robot.api.deco import not_keyword, keyword, library


@library(scope='Test', auto_keywords=True)
class CompareTwoImages:
    """Library to compare to images, local or using web url.

    = Table of contents =

    - image_source1: path (local ou web) first image
    - image_source2: path (local ou web) secound image
    - similarity_threshold: Value to compare how similar the images are. Default value is 0.9 (90%)

    %TOC%

    = Usage =

    Compare Images    
    ...    ${EXECDIR}/resources/files/images/logo_orbia.png
    ...    ${EXECDIR}/resources/files/images/logo_orbia.png

    Compare Images    
    ...    ${EXECDIR}/resources/files/images/logo_orbia.png
    ...    www.image.com.br/imagem.png

    """

    def __init__(self):
        pass

    @not_keyword
    def load_image(self, image_source):
        if image_source.startswith('http'):
            response = requests.get(image_source)
            img = Image.open(BytesIO(response.content))
        else:
            img = Image.open(image_source)
        return img

    @keyword('Compare Images')
    def compare_images(self, image_source1, image_source2, similarity_threshold=0.9):
        try:
            print(f"Source img 1: {image_source1}")
            print(f"Source img 2: {image_source2}")

            # Carregar as imagens (da web ou local)
            img1 = self.load_image(image_source1).convert('L')
            img2 = self.load_image(image_source2).convert('L')

            # Redimensionar imagens para o mesmo tamanho (se necessário)
            if img1.size != img2.size:
                img2 = img2.resize(img1.size)

            # Converter imagens para arrays NumPy
            arr1 = np.array(img1)
            arr2 = np.array(img2)

            # Calcular a similaridade usando SSIM
            sim_index, _ = ssim(arr1, arr2, full=True)
            sim_index_perc = sim_index * 100

            # Verificar se a similaridade está acima do limiar
            if sim_index >= similarity_threshold:
                print(
                    f"The images are similar. Similarity: {sim_index_perc:.2f}, Is expected {similarity_threshold * 100} of Similarity")
            else:
                raise Exception(
                    f"The images are not similar. Similarity: {sim_index_perc:.2f}, Is expected {similarity_threshold * 100} of Similarity")
        except Exception as error:
            print(error)
            raise
    
    @keyword('Calculate Image Similarity')
    def calculate_image_similarity(self, image1_path, image2_path, similarity_threshold=90):
        """
        Compares two images and validates the similarity.

        Args:
            image1_path (str): Path to the first image.
            image2_path (str): Path to the second image.
            similarity_threshold (float): Minimum percentage of desired similarity (0 to 100).

        Returns:
            float: Calculated similarity percentage.

        Raises:
            SimilarityError: If the similarity is less than the specified limit.
        """
        img1 = Image.open(image1_path).convert("RGB")
        img2 = Image.open(image2_path).convert("RGB")
        diff = ImageChops.difference(img1, img2)

        diff_data = sum(sum(pixel)
                        for pixel in diff.getdata())  # Soma os componentes RGB
        total_pixels = img1.size[0] * img1.size[1] * 3  # Total de valores RGB
        similarity = 1 - (diff_data / 255 / total_pixels)
        similarity_percentage = similarity * 100

        if similarity_percentage < similarity_threshold:
            raise Exception(
                f"The similarity is {similarity_percentage:.2f}%, less than the {similarity_threshold}% threshold."
            )

        print(
            f"The images are similar with {similarity_percentage:.2f}% similarity.")
        return similarity_percentage

