# voxholder

a placeholder image generator that uses photos from our [flickr pool](https://www.flickr.com/groups/sbnation). visit [voxholder.herokuapp.com/](http://voxholder.herokuapp.com/) to check it out.

## usage

just use `http://voxholder.herokuapp.com/[width]/[height]` as your image sources in your static prototypes. for example, `<img src="http://voxholder.herokuapp.com/640/480" />` becomes:

<img src="http://voxholder.herokuapp.com/640/480" />

note: if you use the same url several times in the same page, they might all return the same image. if you want to make sure they're all different images, try appending a random query string at the end of the url, e.g. `<img src="http://voxholder.herokuapp.com/640/480?12345" />`.
