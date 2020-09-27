import React from 'react';
import Table from '../../components/Table';
import RslListSimply from './RslListSimply';
import RslList from './RslList';


const getIndex = (index, field, props, flg) => {
  const res = [];
  if (index % 3 === 0 && flg === 1) {
    res.push(<RslListSimply {...props} key={field} index={index} item={props.formValues.rslListData[index]} field={field} />);
  } else if (index % 3 === 1 && flg === 2) {
    res.push(<RslListSimply {...props} key={field} index={index} item={props.formValues.rslListData[index]} field={field} />);
  } else if (index % 3 === 2 && flg === 3) {
    res.push(<RslListSimply {...props} key={field} index={index} item={props.formValues.rslListData[index]} field={field} />);
  } else if (flg === 0) {
    res.push(<RslList {...props} key={field} index={index} item={props.formValues.rslListData[index]} field={field} resulterror={props.formValues.resulterror[index]} />);
  }
  return res;
};

const load = (props) => {
  const res = [];
  let table = null;
  if (props.formValues !== undefined && props.formValues.resultFlg) {
    res.push(<tbody>{props.fields.map((field, index) => (getIndex(index, field, props, 0)))}</tbody>);
  } else {
    for (let i = 1; i < 4; i += 1) {
      table = (
        <td>
          <Table style={{ width: '600px' }}>
            <thead>
              <tr>
                <th style={{ textAlign: 'left' }}>検査項目名</th>
                <th colSpan="2">検査結果</th>
                <th>前回結果</th>
              </tr>
            </thead>
            {props.formValues !== undefined && props.fields.map((field, index) => (
              <tbody>
                {getIndex(index, field, props, i)}
              </tbody>
            ))}
          </Table>
        </td>
      );
      res.push(table);
    }
  }
  return res;
};

const header = (props) => {
  let res = '';
  if (props.formValues !== undefined && props.formValues.resultFlg) {
    res = (
      <thead>
        <tr>
          <th style={{ textAlign: 'left' }}>検査項目名</th>
          <th colSpan="2">検査結果</th>
          <th>文章</th>
          <th colSpan="6" style={{ textAlign: 'left' }}>コメント</th>
          <th>前回({props.formValues.lastInfo !== '' && props.formValues.lastInfo !== undefined ? props.formValues.lastInfo : 'なし'})</th>
        </tr>
      </thead>
    );
  }
  return res;
};

// 住所情報の入力フィールド
const SearchResult = (props) => (
  <Table striped hover>
    {header(props)}
    {load(props)}
  </Table>
);

export default SearchResult;

