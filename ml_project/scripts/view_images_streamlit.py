"""
Minimal Streamlit app to browse the dataset by class and index.
Run: pip install streamlit pillow
     streamlit run scripts/view_images_streamlit.py
"""
import streamlit as st
from pathlib import Path
from PIL import Image
import random

ROOT_DEFAULT = Path('data/Indian_Face_Dataset/IMFDB FR dataset/IMFDB FR dataset')

st.title('Dataset Browser')
root_input = st.text_input('Dataset root', str(ROOT_DEFAULT))
root = Path(root_input)

if not root.exists():
    st.error(f'Path {root} does not exist')
else:
    classes = sorted([p.name for p in root.iterdir() if p.is_dir()])
    if not classes:
        st.warning('No class subdirectories found')
    else:
        sel = st.selectbox('Class', classes)
        class_dir = root / sel
        imgs = [p for p in class_dir.iterdir() if p.suffix.lower() in ('.jpg', '.jpeg', '.png')]
        st.write(f'{len(imgs)} images found for `{sel}`')

        if imgs:
            idx = st.slider('Image index', 0, max(0, len(imgs) - 1), 0)
            try:
                im = Image.open(imgs[idx]).convert('RGB')
                st.image(im, caption=imgs[idx].name, use_column_width=True)
            except Exception as e:
                st.error(f'Could not open image: {e}')

            if st.button('Show random grid'):
                cols = st.number_input('Columns', min_value=1, max_value=6, value=3)
                n = min(12, len(imgs))
                sampled = random.sample(imgs, n)
                rows = (n + cols - 1) // cols
                for r in range(rows):
                    cols_widgets = st.columns(cols)
                    for c in range(cols):
                        i = r * cols + c
                        if i < n:
                            with cols_widgets[c]:
                                try:
                                    img = Image.open(sampled[i]).convert('RGB')
                                    st.image(img, caption=sampled[i].name)
                                except Exception as e:
                                    st.write('error')
