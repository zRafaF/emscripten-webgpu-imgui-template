# WebGPU with Emscripten and ImGUI template

This repo is a basic start template for using WebGPU with Emscripten and ImGUI. It provides all the necessary files (**excluding the Emscripten compiler**) to build a basic WASM graphics ready app.

```sh
make          # Makes the .o files and Wasm

make serve    # Starts the development server
```

## Setup

### How to install Emscripten

Pleas refer to the documentation <https://emscripten.org/docs/getting_started/downloads.html>.

If you are on **windows** and want to add `emcc` | `em++` to the global environment variables you can follow this steps:

1. Open the `Environment Variables` panel.
2. Under `System variables` look for the `Path` variable.
3. Click `edit`-> `new`.
4. Paste the path to your `emscripten` build, it should look something like `C:\[path_to_your_emsdk]\emsdk\upstream\emscripten`.
5. Press `OK`.

> This article shows some useful pics <https://www.imatest.com/support/docs/23-1/editing-system-environment-variables/#Windows>

### VS Code
If you want the **intellisense** to work with Visual Studio Code you will have to provide the path to your `emsdk`.

You can change the default value in the file: `.vscode/settings.json`,

```json
{
    "env": {
        "emsdkPath": "D:\\Development\\emsdk"
    },
    ...

}
```

> `/` on MacOS or Linux, `\` on Windows 



## License

Please refer to [WebGPU](https://github.com/gpuweb/gpuweb), [Dear ImGui](https://github.com/ocornut/imgui) and [Emscripten](https://github.com/emscripten-core/emscripten) licenses.
