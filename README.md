# gNugget-i18n

Translation files for [GoldenNugget](https://github.com/awesomenull-dev/GoldenNugget).

## How to translate

1. **Get Qt Linguist** (free, no coding needed):
   - Comes with the free [Qt Online Installer](https://www.qt.io/download-qt-installer) — install just "Qt Linguist" under Developer & Designer Tools, no full Qt SDK needed.
   - Or via pip: `pip install pyside6` gives you `pyside6-linguist`.

2. **Pick your language's `.ts` file** in [`translations/`](translations/).
   - If your language doesn't exist yet, copy `Nugget_en.ts` (the source/base file) and rename it, e.g. `Nugget_fr.ts`.

3. **Open it in Qt Linguist** and translate the strings. Save when done.

4. **Open a Pull Request** with your updated `.ts` file.

That's it — no need to touch the main GoldenNugget codebase.

## Updating the source strings

`Nugget_en.ts` is the base file, regenerated from the GoldenNugget source
whenever the UI changes. If you're a maintainer syncing from the main repo:

```bash
pyside6-lupdate src/gui/main_window.py src/gui/pages/page.py src/gui/pages/reset_dialog.py \
  src/gui/pages/main/*.py src/gui/pages/tools/*.py src/gui/dialogs.py src/qt/mainwindow.ui \
  src/devicemanagement/device_manager.py src/exceptions/*.py src/tweaks/*.py \
  src/tweaks/posterboard/*.py src/tweaks/posterboard/template_options/*.py src/controllers/*.py \
  -ts gNugget-i18n/translations/Nugget_en.ts
```

Then merge the updated `Nugget_en.ts` here — existing translations for
unchanged strings carry over automatically; new/changed strings show up as
untranslated for translators to fill in.

## Getting translations back into GoldenNugget

Maintainers: before a release, copy the finished `.ts` files from
[`translations/`](translations/) into the main repo's
`src/qt/translations/` and compile:

```bash
pyside6-lrelease src/qt/translations/Nugget_{language code}.ts -qm src/qt/translations/Nugget_{language code}.qm
```

## Questions

Open an issue here, or ask in the main
[GoldenNugget repository](https://github.com/awesomenull-dev/GoldenNugget)'s
Discussions.
