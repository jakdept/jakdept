# Packaging Woes

One of the things I do as a part of my job is write packages to do things.
I would argue that I do it rather well.

I dislike a lot of the current state of packaging out there in the wild.
It frustrates me.
This is my explanation of why.

## You made a widget

Let's say you made some widget thing.
Keep it simple, hypothetically it's written in `go` or `rust` or `C` .
Why? You get the code and run a compile and you get the binary.
No dependencies, you just call that binary and it runs.

This thing you made is super useful.
You would like to share it with the world.
You would like others to be able to run it as well.
Unfortunately, there are dragons waiting all around.
Woe is you and you don't even know it.

## First a makefile

Ok, so your first thought is probably:

> I won't always be around to build this.
> I should standardize the build with a `makefile`

So, you go and google "makefile" and you find something like:
<https://golangdocs.com/makefiles-golang>

That's a farily short guide, by the end you have a simple-ish makefile:

```makefile
BINARY_NAME=main.out
 
all: build test

deps:
    go get github.com/gorilla/websocket
 
build:
    go build -o ${BINARY_NAME} main.go
 
test:
    go test -v ./...
 
run:
    go build -o ${BINARY_NAME} main.go
    ./${BINARY_NAME}
 
clean:
    go clean
    rm ${BINARY_NAME}
```

Thing is, before that `makefile` you only had to know:

* `go test -v ./...`
* `go build .`

And then your makefile starts to grow.
You don't even really need the `run` action?
What if you don't have go installed? Don't you need something to install it?
This isn't a clean environment?
Hey let's add a clean environment by adding a dockerfile!
Ok, someone could forget to build the image, so let's add an action to do that.
Let's change the `go build` to call docker so it happens in the container.

Before long, your makefile can be longer than your code.
Now you not only have to know the language of your code, but also `make` .
Also, by adding a `makefile` , you _added build dependencies_ for your thing.

I'm not arguing against a simple `Makefile` that only does what it needs to do.
I strongly disagree with a `Makefile` that adds complexity.
Simplicity is a feature that takes dedication to build.

## Making a RPM package

So, you want people to be able to install your thing on something that uses RPMs.
RIP CentOS.

You go and you find <https://access.redhat.com/sites/default/files/attachments/rpm_building_howto.pdf>.
And you read up on it and start to make a package.
You've got this perfectly created `.spec` file, and you can `rpmbuild` on your machine and it's good.

Either way, if you followed the guide, you probably now have at least two folders:

* One for your code
* One for the packaging of your widget

My point is RPM strongly pushes separating the packaging from the code, and the two are not distinct.
That specfile is never used/run without that code.
If you release the package to the world, code changes mean you have to create a new package as well.
The separation splits one thing into two things and adds work at the same time.

Instead, ideally, `rpmbuild` (or similar) should first support a model with the specfile sitting in the codebase.
This should be the first taught example.
The SME's (Subject Matter Experts) for the code should have first control over the packages.
Contributions from SME's for packaging should be welcomed, but the developers own the code.

To be clear, not all projects should follow that model.
Large (very large) projects should have a separate packaging repository.
There is enough complexity that the divison of work improves the end product.

My favorite upside to an RPM package?
Once you're comfortable with the RPMSpec format, I like having a lot of things just in one file:

* the package name / version / arch / authors
* the package dependencies / build dependencies
* the prep / build / install just being in a file is nice
* the pre and post install scripts are often simple, and it's nice to just have them in a file
* I'd argue that the changelog would be better included from a json file, but best as a choice

## Making a Debian package

Making a Debian package is mostly the same thing, with three exceptions:

* `rpmbuild` is documented far better than `debuild`.
  * Why would `debuild` need super clear documentation? It's makefiles and bash scripts?
  * Packagers are going to be the only ones using `debuild` anyway, and they're on our mailing list.
* Debian packaging starts with the deep end of the pool.
  * The documentation seems to strongly encourage separate developers and maintainers.
  * To me that feels like gatekeeping.
* `rpmbuild` uses a single spec file,  `debuild` uses a folder.
  * Files in that folder have specific names and do specific things.
  * Distinct files ends up just spreading out the complexity.
  * You need the files in that folder to get started.
  * But it's ok, there's a script to create the boilerplate.
  * That boilerplate is technical debt. Handed to the maintainer. That does not understand it.

Flip side? I like the idea of _optionally_ having parts of an `rpmspec` file be distinct files.

If I have a 500 line `rpmspec` file and my `%prep` , `%build` , and `%install` steps are already in a `makefile` , that's great.
But maybe having a `%changelog -f changelog.json` as an option to move the changelog to a distnct file is a good idea.

More importantly, for both, why not just use standard `json` or `yaml` for the changelog?
The argument from both side is probably pushing the other side to convert, but that argument never ends.
Instead, lead by adopting a larger standard.

## Debbuild

<https://github.com/debbuild/debbuild>

`debbuild` is not `debuild` .
`debbuild` is a tool that builds a Debian package from an RPM specfile.
This is what I want so very badly.

The problem I've had in the past was it added an extra dependency on itself.
I need to go back and try this one again.

## FPM (Effing Package Management)

<https://github.com/jordansissel/fpm>

I like the name.
And it builds working packages for both `rpm` and `deb` .

But this seems to be half a folder of files like `debuild` .
And the other half seems to be moving the metadata (package name/version) to flags.
If the command to build a package is 20 lines, it'll just end up in a `makefile` .
Then you potentially have `makefile` calling `fpm` calling a `makefile` again?

Where did we go wrong?

## GoReleaser

Hey all of this sounds bad, let's just make a language specific packaging tool to release packages for _____.

I'm picking on GoReleaser because I know Go and I've seen it used.
But a lot of projects require something more complicated than making a binary and putting it somewhere.

This smells like someone saw the complexity above, nope'd out of it, and did something simpler for what they needed.
I appreciate that - there are nightmares above.
But this solution only goes so far.

## Making a Helm Chart

To be fair, I have the same complaints with helm charts as others.

You're encouraged to use a separate repository for your chart.
And run this script to get started that creates a bunch of boilerplate.

If every file in that boilerplate had comments and a link to more documentation, it would be better.
Better yet, cut out the parts most users are not going to need and simplify it.
Cognitive overload is totally a thing, do not ambush a maintainer that just started a project.
