type t
@new external create: (array<t>, {"type": string}) => t = "Blob"
@scope("URL") @val external createUrl: t => string = "createObjectURL"
