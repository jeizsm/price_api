defmodule DistanceService.DistanceRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          start: DistanceService.DistanceRequest.Coordinates.t(),
          end: DistanceService.DistanceRequest.Coordinates.t()
        }
  defstruct [:start, :end]

  field :start, 1, type: DistanceService.DistanceRequest.Coordinates
  field :end, 2, type: DistanceService.DistanceRequest.Coordinates
end

defmodule DistanceService.DistanceRequest.Coordinates do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          lat: float,
          lon: float
        }
  defstruct [:lat, :lon]

  field :lat, 1, type: :double
  field :lon, 2, type: :double
end

defmodule DistanceService.DistanceResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          time: integer,
          distance: integer
        }
  defstruct [:time, :distance]

  field :time, 1, type: :int32
  field :distance, 2, type: :int32
end

defmodule DistanceService.Distance.Service do
  @moduledoc false
  use GRPC.Service, name: "distance_service.Distance"

  rpc :GetDistance, DistanceService.DistanceRequest, DistanceService.DistanceResponse
end

defmodule DistanceService.Distance.Stub do
  @moduledoc false
  use GRPC.Stub, service: DistanceService.Distance.Service
end
