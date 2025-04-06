from PIL import Image, ImageChops
import numpy as np
import requests
from io import BytesIO
from skimage.metrics import structural_similarity as ssim
from robot.api.deco import not_keyword, keyword, library


@library(scope='Test', auto_keywords=True)
class CompareTwoImages:
    """Library to compare two images, local or using web URL.

    This library provides functionality to compare images and determine their similarity.
    It can work with local image files or images from web URLs.

    = Table of contents =

    - image_source1: Path (local or web) to the first image
    - image_source2: Path (local or web) to the second image
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
        """Initialize the CompareTwoImages library."""
        pass

    @not_keyword
    def load_image(self, image_source):
        """Load an image from a local file or web URL.

        Args:
            image_source (str): Path to the image (local file path or URL)

        Returns:
            PIL.Image: Loaded image object
        """
        if image_source.startswith('http'):
            response = requests.get(image_source)
            img = Image.open(BytesIO(response.content))
        else:
            img = Image.open(image_source)
        return img

    @keyword('Compare Images')
    def compare_images(self, image_source1, image_source2, similarity_threshold=0.9):
        """Compare two images and determine if they are similar.

        This method uses the Structural Similarity Index (SSIM) to compare images.
        If the images have different sizes, the second image will be resized to match the first.

        Args:
            image_source1 (str): Path to the first image (local file path or URL)
            image_source2 (str): Path to the second image (local file path or URL)
            similarity_threshold (float): Minimum similarity threshold (0.0 to 1.0, default: 0.9)

        Raises:
            Exception: If the images are not similar enough based on the threshold
        """
        try:
            print(f"Source img 1: {image_source1}")
            print(f"Source img 2: {image_source2}")

            # Load images (from web or local)
            img1 = self.load_image(image_source1).convert('L')
            img2 = self.load_image(image_source2).convert('L')

            # Resize images to the same size (if necessary)
            if img1.size != img2.size:
                img2 = img2.resize(img1.size)

            # Convert images to NumPy arrays
            arr1 = np.array(img1)
            arr2 = np.array(img2)

            # Calculate similarity using SSIM
            sim_index, _ = ssim(arr1, arr2, full=True)
            sim_index_perc = sim_index * 100

            # Check if similarity is above the threshold
            if sim_index >= similarity_threshold:
                print(
                    f"The images are similar. Similarity: {sim_index_perc:.2f}%, Expected: {similarity_threshold * 100}% of Similarity")
            else:
                raise Exception(
                    f"The images are not similar. Similarity: {sim_index_perc:.2f}%, Expected: {similarity_threshold * 100}% of Similarity")
        except Exception as error:
            print(error)
            raise

    @keyword('Calculate Image Similarity')
    def calculate_image_similarity(self, image1_path, image2_path, similarity_threshold=90):
        """Compare two images and validate their similarity using pixel difference method.

        This method uses pixel-by-pixel comparison to determine image similarity.

        Args:
            image1_path (str): Path to the first image (local file path)
            image2_path (str): Path to the second image (local file path)
            similarity_threshold (float): Minimum percentage of desired similarity (0 to 100, default: 90)

        Returns:
            float: Calculated similarity percentage

        Raises:
            Exception: If the similarity is less than the specified threshold
        """
        img1 = Image.open(image1_path).convert("RGB")
        img2 = Image.open(image2_path).convert("RGB")
        diff = ImageChops.difference(img1, img2)

        diff_data = sum(sum(pixel)
                        for pixel in diff.getdata())  # Sum of RGB components
        total_pixels = img1.size[0] * img1.size[1] * 3  # Total RGB values
        similarity = 1 - (diff_data / 255 / total_pixels)
        similarity_percentage = similarity * 100

        if similarity_percentage < similarity_threshold:
            raise Exception(
                f"The similarity is {similarity_percentage:.2f}%, less than the {similarity_threshold}% threshold."
            )

        print(
            f"The images are similar with {similarity_percentage:.2f}% similarity.")
        return similarity_percentage
