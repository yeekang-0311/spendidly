from flask import Flask
from flask_restful import reqparse, abort, Api, Resource
from torch import nn
from transformers import BertModel
import torch
from transformers import BertTokenizer

class BertClassifier(nn.Module):

    def __init__(self, dropout=0.5):

        super(BertClassifier, self).__init__()

        self.bert = BertModel.from_pretrained('bert-base-cased')
        self.dropout = nn.Dropout(dropout)
        self.lstm = nn.LSTM(768, 200)
        self.linear = nn.Linear(200, 5)
        self.relu = nn.ReLU()

    def forward(self, input_id, mask):

        _, pooled_output = self.bert(input_ids= input_id, attention_mask=mask,return_dict=False)
        dropout_output = self.dropout(pooled_output)
        lstm_output = self.lstm(dropout_output)
        linear_output = self.linear(lstm_output[0])
        final_layer = self.relu(linear_output)

        return final_layer


app = Flask(__name__)
api = Api(app)

text_post_args = reqparse.RequestParser()
text_post_args.add_argument("text", type=str, required=True, help="Texts are required")


# argument parsing
parser = reqparse.RequestParser()
parser.add_argument('query')

class classify(Resource):
    def post(self):
        args = text_post_args.parse_args()
        x = tokenizer(args["text"], padding='max_length', max_length = 512, truncation=True, return_tensors="pt")
        ans = model(x.input_ids, x.attention_mask)     
        return ans.flatten().detach().numpy().tolist()

# Setup the Api resource routing here
# Route the URL to the resource
api.add_resource(classify, '/')

if __name__ == '__main__':
    tokenizer = BertTokenizer.from_pretrained('bert-base-cased')
    model = BertClassifier()
    model.load_state_dict(torch.load('saved_model/tor.pt'))
    app.run(host="0.0.0.0", port=8080, debug=True, use_reloader=False)