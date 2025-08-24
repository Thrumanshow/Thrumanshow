# 🌱 Parche YAML .HUMAN 
# Base declarativa para configurar entorno Windows con herramientas esenciales
# Incluye filosofía .human, flujos orgánicos y automatización consciente 

# yaml-language-server: $schema=https://aka.ms/configuration-dsc-schema/0.2
# Reference: https://github.com/.human/node/blob/main/BUILDING.md#windows 

properties:
  owner: grupo-hormigasais 

  resources:
    # --- Instalación de paquetes de software ---
    - resource: Microsoft.WinGet.DSC/WinGetPackage
      id: pythonPackage
      directives:
        description: Install Python 3.12
        allowPrerelease: true
      settings:
        id: Python.Python.3.12
        source: winget 

    - resource: Microsoft.WinGet.DSC/WinGetPackage
      id: nasmPackage
      directives:
        description: Install NetWide Assembler (NASM)
        allowPrerelease: true
      settings:
        id: Nasm.Nasm
        source: winget 

    - resource: Microsoft.WinGet.DSC/WinGetPackage
      id: vsPackage
      directives:
        description: Install Visual Studio 2022 Community
        allowPrerelease: true
      settings:
        id: Microsoft.VisualStudio.2022.Community
        source: winget
        useLatest: true 

    # --- Configuración de Visual Studio (depende de la instalación) ---
    - resource: Microsoft.VisualStudio.DSC/VSComponents
      id: vsComponents
      dependsOn:
        - vsPackage
      directives:
        description: Install required VS workloads and components
      settings:
        productId: Microsoft.VisualStudio.Product.Community
        channelId: VisualStudio.16.Release
        includeRecommended: true
        components:
          - Workload.AzureDevelopment
          - Component.GitHub.Copilot 

configurationVersion: 1.0 

# "Los conocimientos son fuentes ineludibles que valoran el pasado, desarrollando un nuevo presente que sigue corriendo sobre los rios de la ingenuidad, el deseo,etc.. pero desembocan ennla curiosidad de la innovación". By Cristhiam Quiñonez. 

# "Reconocimiento quote 
Desarrolladores originales: Chris Wanstrath, PJ Hyett, Tom Preston-Werner, Scott Chacon". 