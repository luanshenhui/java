import React from 'react';
import { Field, reduxForm, change, formValueSelector } from 'redux-form';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';

// 団体ガイド
import ConsultListGuide from '../common/ConsultListGuide';
import { openConsultListGuide } from '../../modules/reserve/consultModule';

import TextBox from '../../components/control/TextBox';

// --------------------------------------------------------------------------------
// Labelコンポーネントの定義
// (今回のサンプルではここで定義しているが、実際は共通コンポーネントとして管理することにする)
// (サンプルゆえpropTypesを割愛しているが本来は望ましくない)
// --------------------------------------------------------------------------------
// eslint-disable-next-line react/prop-types
const Label = (props) => <span>{props.input.value}</span>;

// --------------------------------------------------------------------------------
// ConsultListGuideSampleFormの定義
// --------------------------------------------------------------------------------
let ConsultListGuideSampleForm = (props) => (
  <form onSubmit={props.onSubmit}>
    <p><input type="submit" value="受診者の検索" /></p>
    <p>受診日　　　：<Field name="csldate" component={TextBox} /></p>
    <p>検索条件　　：<Field name="keyword" component={TextBox} /></p>
    <p>対象予約番号：<Field name="rsvno" component={TextBox} /></p>
    <p>受診コース　：<Field name="csname" component={TextBox} /></p>
    <p>個人氏名　　：<Field name="name" component={Label} /></p>
  </form>
);

// ConsultListGuideSampleFormをRedux-Form化
// これにより、上のFieldコンポーネントで定義した4つの項目がStateで管理されることになる
ConsultListGuideSampleForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'consultListGuideSampleForm',
})(ConsultListGuideSampleForm);

// propTypesの定義
ConsultListGuideSampleForm.propTypes = {
  // 親から渡されるprops
  onSubmit: PropTypes.func.isRequired,
};

// --------------------------------------------------------------------------------
// ConsultListGuideSampleコンテナの定義
// --------------------------------------------------------------------------------
const ConsultListGuideSample = (props) => (
  <div>
    {/* ConsultListGuideSampleFormの設置。かつここで定義したonSubmitはConsultListGuideSampleFormのpropsで参照することができる。 */}
    <ConsultListGuideSampleForm onSubmit={(event) => {
      event.preventDefault();
      // ボタンがクリック(=submit)されたらガイドのオープン処理を呼び出す。その際、検索条件の初期値を渡す。
      // ・propsに定義されているonOpenという関数がガイドのオープン処理。この正体は後で登場する。
      // ・また引数としてkeywordというprops値を渡しているが、この正体はこの後のセクションを参照。
      props.onOpen({
        csldate: props.csldate,
        keyword: props.keyword,
      });
    }}
    />
    {/* 団体ガイドのコンポーネント。ガイドで団体が選択されたら選択後の処理を呼び出す。 */}
    {/* ・propsに定義されているonSelectedという関数がガイドのオープン処理。この正体もonOpenと同様、後で登場する。 */}
    <ConsultListGuide onSelected={(item) => props.onSelected(item)} />
  </div>
);

// Componentのプロパティとして紐付けるState(状態)の定義
const selector = formValueSelector('consultListGuideSampleForm');
const mapStateToProps = (state) => ({
  csldate: selector(state, 'csldate'),
  keyword: selector(state, 'keyword'),
});

// Componentのプロパティとして紐付けるAction(アクション)の定義
// ここで、先に登場したonOpen、onSelectedという関数をpropsとして参照させるための記述を行っている
// 関数はそれぞれ、Stateの値を操作するためのActionを呼び出す処理を行っている
// 正確にはAction（＝オブジェクト）を作成するためのAction Creatorという処理を呼び出し、得られたActionをStoreにDispatchする（＝送る）という工程である
// Storeは送られたActionに応じて処理を行い、Stateを更新する。これがいわゆるReducerである。
// State値が更新されることにより、それと連動している画面の各所も更新され、「何かの処理を行うと何かの値が変わる」という一連の処理が完結する。
const mapDispatchToProps = (dispatch) => ({
  // ガイドオープン時の処理(formのonSubmitイベントから呼び出される)
  onOpen: (conditions) => {
    // 「団体ガイドを開く」Actionを呼び出す
    // その際、検索条件の初期値を引数で渡す
    dispatch(openConsultListGuide({ conditions }));
  },
  // ガイド項目選択時の処理(ConsultListGuideのonSelectedイベントから呼び出される)
  onSelected: (item) => {
    // 「指定フォームの指定項目を指定した値で変更する」Actionを呼び出す
    dispatch(change('consultListGuideSampleForm', 'rsvno', item.rsvno));
    dispatch(change('consultListGuideSampleForm', 'csname', item.csname));
    dispatch(change('consultListGuideSampleForm', 'name', item.lastname + item.firstname));
  },
});

// propTypesの定義
ConsultListGuideSample.propTypes = {
  onOpen: PropTypes.func.isRequired,
  csldate: PropTypes.string,
  keyword: PropTypes.string,
  onSelected: PropTypes.func.isRequired,
};

// defaultPropsの定義
ConsultListGuideSample.defaultProps = {
  csldate: undefined,
  keyword: undefined,
};

// ConsultListGuideSampleFormコンポーネントにmapStateToPropsとmapDispatchToPropsを結合し、Containerが完成する
export default connect(mapStateToProps, mapDispatchToProps)(ConsultListGuideSample);
