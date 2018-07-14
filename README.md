# DynamicMoleculeLoader
Example how to make dynamic movement of molecule points using Core Animation and layers
<img align="left" width="200" src="/ReadmeSources/MoleculeLoader.gif" />
<img width="600" src="/ReadmeSources/3.png" />


Clone or Download a Demo project. If you want to add that loader to your own project - copy and paste files from "Loader" folder.



---

### Usage

<img width="800" src="/ReadmeSources/1.png" />

Pass to Loader:
* view - your scene view where you want to see a molecule
* initialPoints (Optional) - by default the Loader will use 4 points to build a molecula
* timeInterval (Optional) - Loader will stop animation and remove itself after this interval
* completion (Optional) - will be called after animation ends

``` swift

	class func show(in view: UIView,
			initialPoints: [CGPoint]? = nil, 
			timeInterval: CFTimeInterval? = nil,  
			withCompletionBlock completion: @escaping (Loader) -> Void)
```


  
### LICENSE
```
MIT License

Copyright (c) 2017 Anton Nechayuk

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

