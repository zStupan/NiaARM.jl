using NumAssociationRules
using Test

function TestDatasetLoading(dataset)
    df = load_dataset(dataset)
    features = preprocess_data(df)
    return length(features)
end

@test TestDatasetLoading("wiki.csv") == 14
